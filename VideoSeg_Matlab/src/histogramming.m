function [id_hist,tr_label_map] = histogramming(imname,...
    region_map, XYT,tr_id, tr_labels,para)

%% input:
%% region_maps : cell array of super pixel
%% edge_maps   : cell array of all edge_maps
%%
close all;
if ~exist('para.sample_step','var') | isempty(para.sample_step)
    para.sample_step = 4;
end
p = para.p;
q = para.q;
t=imname.t;
nSegs=max(max(region_map));
cls_ids=setdiff(unique(tr_labels),0);

tinds=find(XYT(3,:)==t);

%% initial trlabels into different cluster
tr_label_map=zeros(p,q);
inds=sub2ind([p,q],XYT(2,tinds),XYT(1,tinds));
tr_label_map(inds)=tr_labels(tr_id(tinds));

tr_label_map=get_DTr_label_map_new(tr_label_map,0);

%%
%segments for current frame

% DataCostMap=zeros(prod([p q]),length(cls_ids));
id_hist=zeros(nSegs,length(cls_ids)+1);
for segidx = 1:nSegs
    
    reg_inds = region_map == segidx;
    cluster_ids = tr_label_map(reg_inds);
    
    %% histogram
    id_hist(segidx,:) = histc(cluster_ids, [0 cls_ids])/nnz(reg_inds);

end

id_hist=id_hist(:,2:end);


