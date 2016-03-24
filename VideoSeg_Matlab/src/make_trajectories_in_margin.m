function tr=make_trajectories_in_margin(tr,imagesz)
[XYTor,tr_id]=quick_tr(tr);

XYT=round(XYTor);

inds1=find(XYT(1,:)<=0);
XYTor(1,inds1)=1;
inds2=find(XYT(2,:)<=0);
XYTor(2,inds2)=1;
inds3=find(XYT(1,:)>imagesz(2));
XYTor(1,inds3)=imagesz(2);
inds4=find(XYT(2,:)>imagesz(1));
XYTor(2,inds4)=imagesz(1);

inds_all=union(union(union(inds1,inds2),inds3),inds4);
tr_ids_affected=unique(tr_id(inds_all));

if isempty(tr_ids_affected); return; end

for ii=tr_ids_affected
    tr(ii).XYTPos=XYTor(:,find(ismember(tr_id,ii)));
end


% [XYTor,tr_id]=quick_tr(tr);
%
%
% XYT=round(XYTor);
%
%
% find(XYT(1,:)<=0)
%
% find(XYT(2,:)<=0)
