function [tr_labels,D,N,D_norm]=merge_clusters_by_discontinuity_sequential...
    (tr,Discontinuity,TrNeighbor,tr_labels,imnames,para,verbose)


[D,N,D_norm,D_norm2]=get_metrics(tr_labels,Discontinuity,TrNeighbor);
n_labels=max(tr_labels);
para.thresh_nocc=0.4;
NoCC=(D_norm>para.thresh_nocc & D_norm2>100 & N>para.neib_thresh);

iter=0;

while 1
    iter=iter+1;
    %find neighboring regions
    inds=find(N>para.neib_thresh);
    if isempty(inds)
        break;
    end
    [val,is]=min(D_norm(inds));

    
    [i,j]=ind2sub(size(D_norm),inds(is));

    if (val>para.discontinuity_norm_thresh & D_norm2(i,j)>para.discontinuity_norm_thresh2) ||NoCC(inds(is))
      
        break;
    end
    rest=setdiff(1:max(tr_labels),[i;j]);
    tr_labels_merged=tr_labels;
    tr_labels_merged(tr_labels==i|tr_labels==j)=n_labels+1;
    NoCC_tmp=zeros(n_labels+1);
    NoCC_tmp(rest,rest)=NoCC(rest,rest);
    NoCC_tmp(:,n_labels+1)=[NoCC(:,i);0]|[NoCC(:,j);0];
    NoCC_tmp(n_labels+1,:)=[NoCC(i,:) 0]|[NoCC(j,:) 0];
    [tr_labels,id] = make_label_continuous(tr_labels_merged);
    n_labels=max(tr_labels)
    if n_labels==1
        break;
    end
    NoCC=zeros(n_labels);
    NoCC(1:n_labels,1:n_labels)=NoCC_tmp(id,id);
    [D,N,D_norm,D_norm2]=get_metrics(tr_labels,Discontinuity,TrNeighbor);
    if verbose
        h = plot_trajectory_labels(tr, tr_labels, imnames(1),1,[],1,...
            6);
    end
end


end


function [D,N,D_norm,D_norm2]=get_metrics(tr_labels,Discontinuity,TrNeighbor)
n_labels=max(tr_labels);
%cross-cluster discontinuities%
D = zeros(n_labels);
N = zeros(n_labels);
for i = 1:n_labels
    for j = i:n_labels
        D(i,j)=sum(sum(Discontinuity(tr_labels==i,tr_labels==j)));
        N(i,j)=sum(sum(TrNeighbor(tr_labels==i,tr_labels==j)));
    end
end
D=max(D,D');
N=max(N,N');
D_norm=D./(N+eps);
D_norm2=D_norm./(min(cat(3,ones(n_labels,1)*diag(D_norm)',diag(D_norm)*ones(1,n_labels)),[],3)+eps);
N(1:n_labels+1:end)=0;
end
