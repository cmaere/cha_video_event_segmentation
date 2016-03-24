function region_label_maps=labels2map(labels_all,region_maps)
if iscell(region_maps)
    region_label_maps=cell(length(region_maps),1);
    Nr=getNumberRegions(region_maps);
    for i=1:length(region_maps)
        region_map=region_maps{i};
        [p,q]=size(region_map);
        region_label_map=zeros(p,q);
        labels=labels_all(sum(Nr(1:i-1))+1:sum(Nr(1:i-1))+Nr(i));
        region_label_map(region_map(:)>0)=labels(region_map(region_map(:)>0));
        region_label_maps{i}=region_label_map;
    end
else
    [p,q]=size(region_maps);
    region_label_maps=zeros(p,q);
    labels=labels_all;
    region_label_maps(region_maps(:)>0)=labels(region_maps(region_maps(:)>0));
end
