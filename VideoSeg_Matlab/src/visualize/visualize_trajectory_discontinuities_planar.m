function visualize_trajectory_discontinuities_planar(tr,tr_labels,imnames,D,NN,thresh,figno)

[XYT,tr_id]=quick_tr(tr);

cmap=colormap(jet);


nf = length(imnames);
nr = ceil(sqrt(nf));
nc = ceil(nf/nr);


figure(figno);



for ii = 1:length(imnames)
    t=imnames(ii).t;
    
    if ~isempty(tr_labels);
        h = plot_trajectory_labels(tr, tr_labels, imnames(ii),[],[],[],...
            4);
    else
        img = imread(imnames(ii).name);
        subplot2(nr,nc, ii);
        imshow(img);
    end
    hold on;
    
    [X,Y,tr_id_c]=get_current_xytrid(XYT,tr_id,t);
    [i,j,~]=find(NN(tr_id_c,tr_id_c));
    discontinuities=full(D(sub2ind(size(D),tr_id_c(i), tr_id_c(j))));
    keep=discontinuities>thresh;
    
    colors=map2jet(discontinuities(keep));
    i=i(keep);
    j=j(keep);
    
    pts1=[X(i) Y(i)];
    pts2=[X(j) Y(j)];
    for jj=1:size(pts1,1)
        plot([pts1(jj,1), pts2(jj,1)], [pts1(jj,2) , pts2(jj,2)],'color',colors(jj,:),'linewidth',2);
    end
end



 

end




