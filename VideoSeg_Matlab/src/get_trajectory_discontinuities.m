function [Discontinuity,Neighborhood] = get_trajectory_discontinuities(imnames,tr,tstep,Vtr,para)

[XYT,tr_id]=quick_tr(tr);
ntr=length(tr);
Discontinuity=sparse(ntr,ntr);
Neighborhood=sparse(ntr,ntr);
for t = 1:tstep:length(imnames)
    fprintf('\t\t compute embedding discontinuity: %03d of %03d \n',t,length(imnames));
    [X,Y,tr_id_c]=get_current_xytrid(XYT,tr_id,t);
    [discontinuity,neighborhood] = get_trajectory_discontinuities_per_frame([X Y],  Vtr(tr_id_c,:), tr_id_c,ntr, para);
    Discontinuity=max(Discontinuity,discontinuity);
    % if verbose
%     
%     thresh=0.3;
%     inds=sub2ind([n,n],e(:,1),e(:,2));
%     discontinuity=full(normalize01(Discontinuity(inds)));
%     img=imread(img_path(t).name);
%     visualize_planar_edge_weights(img,pts(e((discontinuity>=thresh),1),:),pts(e((discontinuity>=thresh),2),:),discontinuity((discontinuity>=thresh)),t);
%     title('embedding discontinuities')
% end
    Neighborhood=max(Neighborhood,neighborhood);
end

end


function [Discontinuity,Neighborhood] = get_trajectory_discontinuities_per_frame(pts, V2, tr_id_c,ntr, para)
n=size(pts,1);
DT=Delaunay_im_bdr(para,pts);
e=edges(DT);
Neighborhood=sparse(e(:,1), e(:,2), 1, n, n);
[row, col] = find(Neighborhood);
Neighborhood=max(Neighborhood,Neighborhood');
e=[row col];
[pi,pj] = rowcoltopipj(e(:,1),e(:,2),n);
A=sparse_kernel(V2, n, pi, pj, 0);

affs=A(sub2ind([n,n],e(:,1),e(:,2)));
A=max(A,A');

%trajectory density
tr_density=max(A,[],2);
% if para.verbose>2
%     img=imread(img_path(t).name);
%     tr_density_01=normalize01(tr_density);
%     colors=[tr_density_01 zeros(n,1) zeros(n,1)];
%     figure(1);%('visible','off'),
%     clf
%     imshow(img);
%     hold on;
%     scatter(pts(:,1),pts(:,2),10,colors);
%     title('trajectory densities');
%     % plot_points_active([pts';full(tr_density_01')],img,1);
% end



%double normalized affinities
max_density=max([tr_density(e(:,1)) tr_density(e(:,2))],[],2);
affs_norm=affs./max_density;
affs_norm(affs_norm>0.8)=1;


A_normalized=sparse(e(:,1),e(:,2),affs_norm,n,n);
A_normalized=max(A_normalized,A_normalized');

%discontinuities
ones=sparse(e(:,1),e(:,2),1,n,n);
ones=max(ones,ones');
Discontinuity=ones-A_normalized;
Discontinuity=max(0,Discontinuity);
Discontinuity=min(1,Discontinuity);
%Discontinuity=0;

%  if verbose
%     img=imread(imnames(t).name);
%     inds=sub2ind([n,n],e(:,1),e(:,2));
%     eaff=normalize01(A(inds));
%     visualize_planar_edge_weights(img,pts(e(:,1),:),pts(e(:,2),:),eaff,2);
%     title('embedding affinities')
%  end
% 
% if para.verbose
%     thresh=0.3;
%     inds=sub2ind([n,n],e(:,1),e(:,2));
%     discontinuity=full(normalize01(Discontinuity(inds)));
%     img=imread(img_path(t).name);
%     visualize_planar_edge_weights(img,pts(e((discontinuity>=thresh),1),:),pts(e((discontinuity>=thresh),2),:),discontinuity((discontinuity>=thresh)),t);
%     title('embedding discontinuities')
% end


[is,js,vals]=find(Discontinuity);
Discontinuity=sparse(tr_id_c(is(vals>0)), tr_id_c(js(vals>0)), vals(vals>0), ntr,ntr);
[is,js,vals]=find(Neighborhood);
Neighborhood=sparse(tr_id_c(is), tr_id_c(js), vals, ntr,ntr);

return;
end






function DT=Delaunay_im_bdr(para,pts)
n=size(pts,1);
%add  points on image boundaries%
[tmpx1, tmpy1] = ndgrid([1,para.q],1:5:para.p);
[tmpx2, tmpy2] = ndgrid(1:5:para.q,[1,para.p]);
margin_pts = unique([tmpx1(:), tmpy1(:); tmpx2(:), tmpy2(:)],'rows');

%Triangulation%
X = [pts;  margin_pts];
DT = DelaunayTri(X);

%discard triangles on boundaries%
triangles = DT.Triangulation;
fg_ind = triangles(:,1)<=n & triangles(:,2)<=n & triangles(:,3)<=n;
triangles = triangles(fg_ind, :);
X=DT.X(1:n, :);
DT=TriRep(triangles,X);
end
