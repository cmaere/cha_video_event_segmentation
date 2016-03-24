function A=get_region_affinity_graph(region_map,ucm_map,debug)
[p,q]=size(ucm_map);
centroids=regionprops(region_map,'centroid');
centroids=round(cat(1,centroids(:).Centroid));
% figure,imagesc(region_map); hold on;
% plot(centroids(:,1),centroids(:,2),'*y')
inds=sub2ind([p,q],centroids(:,2),centroids(:,1));
nr=max(region_map(:));
A=zeros(nr);


for th=[0.1:0.05:0.3]
    ucm_map(ucm_map<th)=0;
    
    %  edge_map(ucm_map>threshs)=edge_map_or(edge_map_or>threshs(1));
    %     end
    region_label = bwlabel(~ucm_map,4);
    if debug
        figure,imagesc(region_label);
    end
    D=squareform(pdist(region_label(inds),'hamming'));
    
    %     A((D==0)&(A==0))=1-th;
    A((D==0)&(A==0))=exp(-th^3/(0.1^2));
    
    
end

a=regionprops(region_map,'centroid');
centroids=cat(1,a(:).Centroid);
A_euc=exp(-pdist2(centroids,centroids)/10^2);
A_euc(A_euc<0.001)=0;
A=sparse(A.*A_euc);