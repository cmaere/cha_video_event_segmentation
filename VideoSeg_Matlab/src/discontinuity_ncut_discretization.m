function [tr_labels,tr_labels_rot,Discontinuity,Neighbor]=discontinuity_ncut_discretization(tr,Vtr,Str,imnames,...
    para,verbose)
K=size(Vtr,2);
binsoltr = getbinsol(Vtr);
tr_labels_rot = full(sum(binsoltr.*repmat(1:K, size(binsoltr,1),1),2)');
tiny_cls = get_tiny_cls(tr_labels_rot, para);
tr_labels_rot(ismember(tr_labels_rot,tiny_cls))=0;
[tr_labels_rot] = make_label_continuous(tr_labels_rot);
tr_labels_rot(tr_labels_rot<0)=0;
ntr=length(tr);       


% **discontinuity ** %%
D=sparse([1:ntr],[1:ntr],1./sqrt(sum(Vtr.^2,2)));
Vtr=D*Vtr;
K=size(Vtr,2);
Vtr2=Vtr*sparse(1:K,1:K,sqrt(Str),K,K);
[Discontinuity,Neighbor] = get_trajectory_discontinuities(imnames,tr,...
    1,Vtr2,para);
% discontinuity based merging

[tr_labels]=merge_clusters_by_discontinuity_sequential...
    (tr,Discontinuity,Neighbor,tr_labels_rot,imnames,para,verbose);
h=plot_trajectory_labels(tr, tr_labels, imnames(5), 2, [], 1, 4);
tiny_cls = get_tiny_cls(tr_labels, para);
tr_labels(ismember(tr_labels,tiny_cls))=0;
[tr_labels] = make_label_continuous(tr_labels);
tr_labels(tr_labels<0)=0;
