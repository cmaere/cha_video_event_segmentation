function [LabelMap,DT]=get_DTr_label_map_new(label_map,verbose)

imagesz=size(label_map);

[y,x,labels]=find(label_map);

%compute delaunay tringulation on trajectory points
DT=DelaunayTri([x y]);
X=DT.X;
triangles=DT.Triangulation;
ntri=size(triangles,1);
triangle_labels=[labels(triangles(:,1)) labels(triangles(:,2)) labels(triangles(:,3))];
Labels=[0 ;unique(labels)];
%triangle_labels=triangle_labels(:,1)*100+triangle_labels(:,2)*100



triangle_labels_final=zeros(ntri,1);
switch_inds=sum([abs(triangle_labels(:,2)-triangle_labels(:,1))  + abs(triangle_labels(:,2)-triangle_labels(:,3))],2)~=0;
triangle_labels_final(switch_inds)=0;
triangle_labels_final(switch_inds==0)=triangle_labels(switch_inds==0,1);
triangle_labels=triangle_labels_final;
uni=unique(triangle_labels);

cols=jet(length(uni));

%%


e=DT.edges;


%1. free boundary edges
[xf] = freeBoundary(DT);

free_boundary_edges=ismember(e,[xf;[xf(:,2) xf(:,1)]],'rows');
e_free_boundary=e(ismember(e,[xf;[xf(:,2) xf(:,1)]],'rows')==1,:);
if verbose
    p1=[x(e_free_boundary(:,1)) y(e_free_boundary(:,1))];
    p2=[x(e_free_boundary(:,2)) y(e_free_boundary(:,2))];
    
    [ind, label] = drawline(p1(:,[2 1]),p2(:,[2 1]),imagesz);
    BW=zeros(size(label_map));
    BW(ind)=1;
    figure,imagesc(BW); hold on;
end


%2. different label triangles
inds=find(free_boundary_edges==0);
triangles_attached=edgeAttachments(DT,e(inds,:));
triangles_attached=cat(1,triangles_attached{:});
triangles_attached_labels=[triangle_labels(triangles_attached(:,1)) triangle_labels(triangles_attached(:,2))];
switch_label=(triangles_attached_labels(:,1)-triangles_attached_labels(:,2))~=0;
e_switchtrilabel=   e(inds(switch_label),:);

p1=[[x(e_switchtrilabel(:,1)) y(e_switchtrilabel(:,1))];[x(e_free_boundary(:,1)) y(e_free_boundary(:,1))]];
p2=[[x(e_switchtrilabel(:,2)) y(e_switchtrilabel(:,2))];[x(e_free_boundary(:,2)) y(e_free_boundary(:,2))]];

[ind] = drawline(p1(:,[2 1]),p2(:,[2 1]),imagesz);
BW=zeros(size(label_map));
BW(ind)=1;
BW=imdilate(BW,strel('disk',1));
% hold on;
bw=bwlabel(BW==0,4);
if verbose
    
    figure,imagesc(BW);
    
    
    figure,imagesc(bw); hold on;
end
IC = round(incenters(DT,[1:ntri]'));
ICinds=sub2ind(imagesz,IC(:,2),IC(:,1));
splabels=setdiff(unique(bw(:)),0);
LabelMap=zeros(imagesz);
for i=1:length(splabels);
    spinds=find(bw==splabels(i));
    [~,is]=intersect(ICinds,spinds);
    if length(is)<3 LabelMap(spinds)=0;continue; end
    bins=hist(triangle_labels(is),Labels);
    [maxim,is]=max(bins);
    LabelMap(spinds)=Labels(is);
    
end
if verbose
    figure,imagesc(LabelMap);
    %     figure,imagesc(label_map)
    hold on;
    plot(x,y,'.k')
    triplot(DT.Triangulation,x,y,'linewidth',0.1);
    my_triplot(DT, triangle_labels);
end





