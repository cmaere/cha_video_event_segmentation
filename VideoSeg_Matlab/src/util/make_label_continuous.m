function [tr_cluster,seg_conn_ids] = make_label_continuous(tr_cluster)

pos_inds = tr_cluster > 0;
tr_cluster_pos = tr_cluster(pos_inds);
[seg_conn_ids,~,tr_cluster_pos] = unique(tr_cluster_pos);
tr_cluster(pos_inds) = tr_cluster_pos;
n_seg = length(seg_conn_ids);