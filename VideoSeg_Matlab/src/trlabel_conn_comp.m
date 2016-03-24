function tr_labels=trlabel_conn_comp(Neighbor,tr_labels,para)
centers=1:max(tr_labels);
bins=hist(tr_labels,centers);
[maxim,is]=max(bins);
background_labels=centers(is);
is=bins>0.5*maxim;
background_labels=[background_labels centers(is)];
cnt=max(tr_labels);
for i=1:max(tr_labels)
    ids=find(tr_labels==i);
    neighbor_c=Neighbor(ids,ids);
    [s,bins]=graphconncomp(neighbor_c);
    if (s>0) && (~ismember(i,background_labels));
        for j=2:s
            cnt=cnt+1;
            tr_labels(ids(bins==j))=cnt;
        end
    end
end


tiny_cls = get_tiny_cls(tr_labels, para);
tr_labels(ismember(tr_labels,tiny_cls))=0;
[tr_labels] = make_label_continuous(tr_labels);
tr_labels(tr_labels<0)=0;