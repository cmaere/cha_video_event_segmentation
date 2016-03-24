function [region_label_maps,tr_labels,tr]=segment_video(imnames,para,verbose)

%% Compute Trajectories
disp('compute trajectories');
tr           =  computeTrLDOF(imnames, para);
lens=get_tr_lengths(tr);
tr=tr(lens>=3);



%% Compute Trajectory Graph
disp('compute trajectory affinities');
[Atr]=computeTrAffinities(tr,para,verbose);
inds_keep=sum(Atr,2)>0;
Atr=Atr(inds_keep,inds_keep);
tr=tr(inds_keep);
if verbose
    step=3;
    visualize_trajectory_affinity_graph(tr(1:step:end),[],...
        imnames(2),Atr(1:step:end,1:step:end),[],[],0,1);
end


%% Normalized Cuts on Trajectory Graph
disp('compute trajectory clustering');

[Vtr,Str] = ncut(Atr,para.nv);
K=max(length(find(Str>para.spectral_thresh)),para.nv_min);
[tr_labels,tr_labels_rot,Discontinuity,...
    Neighbor]=discontinuity_ncut_discretization(tr,Vtr(:,1:K),Str(1:K),imnames,para,verbose);
tr_labels=trlabel_conn_comp(Neighbor,tr_labels,para);

if verbose
    plot_trajectory_labels(tr,tr_labels,imnames,2,[],0,5);
    visualize_trajectory_discontinuities_planar(tr,tr_labels_rot,imnames(1),Discontinuity,...
        Neighbor,0,1);
end
%% Trajectory Clusters to Image Regions
disp('compute region graph');
[region_maps,ucm_maps]=get_region_maps(imnames,para);
disp('from trajectory clusters to image regions');
[region_label_maps]=TrajectoryClusters2Regions(tr,tr_labels,region_maps,ucm_maps,imnames,para,verbose);

