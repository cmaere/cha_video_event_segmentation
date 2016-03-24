function [region_maps,ucm_maps]=get_region_maps(imnames,para)
region_maps=cell(length(imnames),1);
ucm_maps=cell(length(imnames),1);
for i=1:length(imnames)
    ucmfile=[para.gpb_dir get_image_name(imnames(i).name) '_pb.mat'];
    [region_maps{i},ucm_maps{i}]=getGpbMap(ucmfile,imnames(i).name,para);
end
end