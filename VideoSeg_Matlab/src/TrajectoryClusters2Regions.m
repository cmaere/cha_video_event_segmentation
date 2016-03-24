function [region_label_maps]=TrajectoryClusters2Regions(tr,tr_labels,region_maps,ucm_maps,imnames,para,verbose)


[region_label_maps_coarse]=MapTrajectoryClusters2Regions(tr,tr_labels,0.5,region_maps,ucm_maps,imnames,para,verbose);


%trajectory voting and re-mapping
[XYT,tr_id]=quick_tr(tr);
XYT=round(XYT);
C=cat(3,region_label_maps_coarse{:});
inds=sub2ind(size(C),XYT(2,:),XYT(1,:),XYT(3,:));
tr_pts_labels=C(inds);
tr_labels=accumarray(tr_id',tr_pts_labels',[],@(x) mode(x));
if verbose
    h=plot_trajectory_labels(tr,...
        tr_labels, imnames(end-10), 1, [], 0, 4);
end
[region_label_maps]=MapTrajectoryClusters2Regions(tr,tr_labels,0.1,region_maps,ucm_maps,imnames,para,0);


    function [region_label_maps,seglabels,potentials]=MapTrajectoryClusters2Regions(tr,tr_labels,overlap_thresh,region_maps,ucm_maps,imnames,para,verbose)
        
        
        cls_ids=setdiff(unique(tr_labels),0);
        numlabels=length(cls_ids);
        
        %% Compute region graph
        disp('compute region graph');
        % [region_maps,ucm_maps]=get_region_maps(imnames,para);
        Nr=getNumberRegions(region_maps);
        nr=sum(Nr);
        Ar=getRegionGraph(region_maps,ucm_maps,imnames,para);
        
        %% compute region seeds
        [XYT,tr_id]=quick_tr(tr);
        XYT=round(XYT);
        [U] = Tr2RegionOverlap(imnames,...
            region_maps, XYT,tr_id, tr_labels,para);
        [overlap_score,argmax]=max(U,[],2);
        seeds=overlap_score>overlap_thresh;
        if verbose
            h=visualize_seg_unary_score([1:length(imnames)],region_maps,Nr,seeds,1);
        end
        
        %% compute region label potentials
        L=diag(sum(Ar,2))-Ar;
        seglabels=multilabel_random_walker(L,find(seeds),U(seeds,:));
        if verbose
            h=visualize_seg_unary_score([2],region_maps,Nr,seglabels,100);
        end
        region_label_maps=labels2map(seglabels,region_maps);
        
        
        
        
        
        function [U,tr_label_maps] = Tr2RegionOverlap(imnames,...
                region_maps, XYT,tr_id, tr_labels,para)
            U=cell(length(imnames),1);
            tr_label_maps=cell(length(imnames),1);
            p = para.p;
            q = para.q;
            cls_ids=setdiff(unique(tr_labels),0);
            if size(cls_ids,1)>size(cls_ids,2)
                cls_ids=cls_ids';
            end
            for l=1:length(imnames)
                progress('region overlapping scores',l,length(imnames));
                t=imnames(l).t;
                region_map=region_maps{l};
                tinds=find(XYT(3,:)==t);
                tr_label_map=zeros(p,q);
                inds=sub2ind([p,q],XYT(2,tinds),XYT(1,tinds));
                tr_label_map(inds)=tr_labels(tr_id(tinds));
                tr_label_map=get_DTr_label_map_new(tr_label_map,0);
                nSegs=max(region_map(:));
                idhist=zeros(nSegs,length(cls_ids));
                pinds=find(region_map>0);
                for cc=1:length(cls_ids)
                    labelid=cls_ids(cc);
                    M=tr_label_map==labelid;
                    idhist(:,cc)=accumarray(region_map(pinds),M(pinds));
                end
                a=regionprops(region_map,'Area');
                region_area=cat(1,a(:).Area);
                U{l}=idhist./(region_area*ones(1,length(cls_ids)));
                
                tr_label_maps{l}=tr_label_map;
            end
            U=cat(1,U{:});
        end
        
        
        
        function Ar=getRegionGraph(region_maps,ucm_maps,imnames,para)
            
           
            Ars=cell(1,length(imnames));
            for ii=1:length(imnames)
                Ars{ii}=get_region_affinity_graph(region_maps{ii},...
                    ucm_maps{ii},0);
                %         id=2;
                %         visualize_region_affinity_unary...
                %             (ones(max(max(region_maps{id})),1),...
                %             double(region_maps{id}),...
                %             Ars{id},[],[],[],11);
            end
            Ardiag=sparse_blkdiag(Ars);
            CrossArs=cell(length(imnames)-1,length(imnames));
            for ii=1:length(imnames)-1
                F=readFlowFile([para.flow_dir 'Forward' ...
                    get_image_name(imnames(ii).name) 'LDOF.flo']);
                CrossArs{ii,ii+1} =set_crossframe_region_graph(region_maps{ii},...
                    region_maps{ii+1},F);
            end
            Nr=getNumberRegions(region_maps);
            Aroffdiag=sparse_blkmat(CrossArs,Nr);
            Ar=threshold_sparse(Ardiag,0)+threshold_sparse(Aroffdiag,0);
        end
        
        
        
        
        
    end

end