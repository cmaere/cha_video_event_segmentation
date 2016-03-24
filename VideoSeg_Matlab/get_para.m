function [para]=get_para(video_dir, extension)

[imnames]          = get_file_list(video_dir,extension);
[p,q,~]            = size(imread(imnames(1).name));



%% Overall Video Stats
para.extension     = extension;                             %% image extension
para.p             = p;                                     %% image height
para.q             = q;                                     %% image width
para.verbose       = 0;                                     %% show middle result
                              

%% Optical Flow & Trajectory

para.flow_dir = setdir([video_dir 'flow/']);                %% Flow directory
para.structure_portion=0;                                   %% Texture threshold1
para.minValue=0.000005;                                            %% Texture threshold2
para.fb_check=0.1;                                          %% ForBackCheck 1
para.fb_check2=0.1;                                           %% ForBackCheck 2
para.g=10;                                                  %% Block Ratio
para.sample_step=4;                                         %% Spatial sample rate
para.flow=get_para_flow(p,q);
para.flow.flow_dir=para.flow_dir;

%% Affinity on Trajectory
para.aggr=5;                              %% velocity support
para.my_var_euk=0.01;                                       %% euclidean variance
para.my_var_ut=0.1;      
para.dist_thresh_x=round(q/6);                              %% spatial neighbour (x)
para.dist_thresh_y=round(p/6);                              %% spatial neighbour (y)

%% Ncut on Trajectory
para.nv_min=5;                                              %% min # eigv
para.spectral_thresh=0.85;                                   %% spectral threshold
para.nv=100;                                                 %% max # nv
para.discontinuity_norm_thresh=0.6;                         %% discontinuity threshold
para.neib_thresh=30;                                        %% neighbour threshold
para.thresh_nocc=0.7;                                       %%
para.tiny_len_thresh=50;                                    %% prune small cluster
para.result_dir=setdir([video_dir 'results/']);
para.discontinuity_norm_thresh=0.25;
para.discontinuity_norm_thresh2=250;
%% Dense Segmentation
para.gpb_dir=setdir(fullfile(video_dir,'gpb/'));                                               
para.pbthresh(1)=0.01;   %% Threshold for pb            
