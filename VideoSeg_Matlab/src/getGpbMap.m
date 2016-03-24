function [region_label,ucm_map]=getGpbMap(ucmfile,...
    imfile,para)
% [ucm_map]=get_edge_map(ucmfile,imfile,para);
[ucm_map]=get_gpb_edge_map(ucmfile,imfile);
ucm_map=ucm_map/max(max(ucm_map));
ucm_map(ucm_map<para.pbthresh(1))=0;

%  edge_map(ucm_map>threshs)=edge_map_or(edge_map_or>threshs(1));
%     end
region_label = bwlabel(~ucm_map,4);
