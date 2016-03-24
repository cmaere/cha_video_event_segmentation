extension  = 'ppm';
fps=15;
verbose=1;
video_dir=['./video/'];

[imnames]    = get_file_list(video_dir,extension);
if isempty(imnames)
    return;
end
ts=cell2struct(num2cell([1:length(imnames)]),'t',1);
imnames = cell2struct([struct2cell(imnames); struct2cell(ts')], ...
    [fieldnames(imnames); fieldnames(ts)], 1);
imnames=imnames(1:min(50,length(imnames)));
[para]     = get_para(video_dir, extension);
verbose=1;
saveim=0;
[region_label_maps,tr_labels,tr]=segment_video(imnames,para,verbose);

save([video_dir 'results.mat'],'tr','tr_labels','region_label_maps');
%% save trajectory labeling
for i=1:length(imnames)
    h=plot_trajectory_labels(tr,tr_labels, imnames(i), 1, [], 1, 4);
    saveas(h,[para.result_dir 'trlabels_' get_image_name(imnames(i).name) '.png']);
end
%% save pixel labelling
nlabels=max(tr_labels)+1;
vals=map2jet([1:nlabels]);
for i=1:length(imnames)
    img=imread(imnames(i).name);
    mask=region_label_maps{i};
    dmask=reshape(vals(mask(:)+1,:),para.p,para.q,3);
    rgb=0.3*im2double(img)+0.7*dmask;
    figure(i);clf;imshow(rgb);
    imwrite(rgb,[para.result_dir 'segments_' get_image_name(imnames(i).name) '.png'])
end

