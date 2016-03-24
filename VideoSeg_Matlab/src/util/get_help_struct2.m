function bk=get_help_struct2(tr,p,q)
[XYT,Ids]=quick_tr(tr);
XYT=round(XYT);
%[Ids]=get_traj_ids(tr);
%XYT=cat(2,tr.XYTPos);
T=XYT(3,:);

for ii=1:max(T)
    inds=find(T==ii);
    X=XYT(1,inds);
    Y=XYT(2,inds);
    traj_ids=Ids(inds);
    %bk{ii}=[X' Y' traj_ids'];
    [A,is]=unique([Y; X]','rows');
    bk{ii}=sparse(A(:,1),A(:,2), traj_ids(is)',p,q);
end


end