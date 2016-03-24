function tiny_cls = get_tiny_cls(tr_cluster, para)

if nargin < 2
    thresh = 5;
end

seg_ids = unique(tr_cluster(tr_cluster>0));
tiny_cls = seg_ids(histc(tr_cluster, seg_ids) <= para.tiny_len_thresh);