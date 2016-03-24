function h=visualize_seg_unary_score(frameIds,region_maps,...
    Nr,seg_labels,figno)
clear RM
cnt=0;
cnto=0;
for t=frameIds
    region_map=region_maps{t};
%     region_label=zeros(size(region_map));
%     for i=1:Nr(t)
%         cnt=cnt+1;
%         if cnt>length(seg_labels) break; end
%         region_label(region_map==i)=seg_labels(cnt);
%     end
    region_label=labels2map(seg_labels(sum(Nr(1:t-1))+1:sum(Nr(1:t))),...
        region_map);
    cnto=cnto+1;
    RM{cnto}=region_label;
end
h=my_showimages(RM,figno);