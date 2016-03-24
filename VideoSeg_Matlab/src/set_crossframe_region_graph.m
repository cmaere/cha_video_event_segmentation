function Ar = ...
    set_crossframe_region_graph(region_map1,region_map2,F)
nr1=max(region_map1(:));
nr2=max(region_map2(:));
%     F=readFlowFile([para.flow_dir 'Forward' ...
%         get_image_name(imname.name) '.flo']);
%     F(:,:,1)=medfilt2(F(:,:,1), [7 7]);
%     F(:,:,2)=medfilt2(F(:,:,2), [7 7]);
[p,q]=size(region_map1);
[Y,X]=ndgrid(1:p,1:q);

xnew=round(X+F(:,:,1));
ynew=round(Y+F(:,:,2));
keep=xnew>=1 & xnew<=q & ynew>=1 & ynew<=p;
inds=sub2ind([p,q],ynew(keep(:)),xnew(keep(:)));
ids=region_map1;
Rtransfer=zeros(p,q);
Rtransfer(inds)=ids(keep);
r=[Rtransfer(:) region_map2(:)];
centers=unique(r,'rows');
centers_unicol=centers(:,1)*10000+centers(:,2);
bins=hist(r(:,1)*10000+r(:,2),centers_unicol);
bins=bins';
Areas1=zeros(nr1,1);
areas1=regionprops(Rtransfer,'area');
areas1=cat(1,areas1(:).Area);
% areas11=zeros(nr1,1);
% areas11(unique(Rtransfer(:)))=areas1;
% areas1=areas11;
%
% assert(~isempty(find(Rtransfer==nr1)));
% assert(nr1==length(areas1));
Areas1(1:length(areas1))=areas1;
Areas2=zeros(nr2,1);
areas2=regionprops(region_map2,'area');
areas2=cat(1,areas2(:).Area);
%     assert(nr2==length(areas2));
% assert(~isempty(find(region_map2==1)));
Areas2(1:length(areas2))=areas2;
keep=centers(:,1)>0 & centers(:,2)>0;
IoUvec=(bins(keep)./(Areas1(centers(keep,1))+...
    Areas2(centers(keep,2))-bins(keep)))+eps;
Ar=sparse(centers(keep,1),centers(keep,2),IoUvec,nr1,nr2);



end