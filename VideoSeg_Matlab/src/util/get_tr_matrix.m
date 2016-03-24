function A=get_tr_matrix(tr,imagesz,t,XYT,Ids)
if nargin<5
[XYT,Ids]=quick_tr(tr);
XYT=round(XYT);
end
%[Ids]=get_traj_ids(tr);
%XYT=cat(2,tr.XYTPos);
T=XYT(3,:);
nf=max(T);
if isempty(t)
    A=zeros(imagesz(1),imagesz(2),nf);
    for ii=1:max(T)
        inds=find(T==ii);
        X=XYT(1,inds);
        Y=XYT(2,inds);
        traj_ids=Ids(inds);
        inds_sp=sub2ind([imagesz nf],round(Y),round(X),ii*ones(size(X)));
        A(inds_sp)=traj_ids;
        %bk{ii}=[X' Y' traj_ids'];
    end
else
    A=zeros(imagesz(1),imagesz(2));
    inds=find(T==t);
    X=XYT(1,inds);
    Y=XYT(2,inds);
    traj_ids=Ids(inds);
    inds_sp=sub2ind([imagesz nf],round(Y),round(X));
    A(inds_sp)=traj_ids;

end

end



