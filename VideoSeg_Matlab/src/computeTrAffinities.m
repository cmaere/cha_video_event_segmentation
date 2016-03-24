function [A]=computeTrAffinities(tr,para,verbose)

%away from 2*cuttoff alays affinity zero

cutoffx=para.dist_thresh_x;
cutoffy=para.dist_thresh_y;
lens=get_tr_lengths(tr);
max_tr_aggr=min(5,lens);
my_var_euk=para.my_var_euk;
my_var_ut=para.my_var_ut;
sample_step = para.sample_step;

ntr=length(tr);

%% neighbors
trFrame=get_help_struct(tr);
[pi, pj] = compute_Atraj_neighbour(tr, trFrame, cutoffx, cutoffy, sample_step,verbose);
[rows,cols] = pipjtorowcol(pi,pj);
clear pi pj


%% spatial distance

[XYT,tr_id]=quick_tr(tr);
vals_euc=compute_tr_max_measurement_diff(XYT(1:2,:)',tr_id,XYT(3,:)',my_var_euk,rows,cols,ntr);

max_aggr=5;
min_aggr=3;
%% velocity
cnt=0;
my_var_utc=my_var_ut;
for aggr=max_aggr:-1:min_aggr
    %
    cnt=cnt+1;
    aggr
    tr_id_on=find(max_tr_aggr>=aggr);
    tic
    keep=find(ismember(rows,tr_id_on)& ismember(cols,tr_id_on));
    toc
    fprintf('len:%d',sum(keep));
    if sum(keep)==0
        break;
    end
    fprintf('%d on trajectories',length(tr_id_on));
    clear Us T tr_ids
    for ii=tr_id_on'
        XYTc=tr(ii).XYTPos;
        v=XYTc(1:2,aggr:end)-XYTc(1:2,1:end-aggr+1);
        if isempty(v)
            error('error!');
        end
        Us{ii}=v;
        T{ii}=XYTc(3,1:end-aggr+1);
        tr_ids{ii}=ii*ones(size(T{ii}));
    end
    tr_id=cat(2,tr_ids{:})';
    Tall=cat(2,T{:})';
    Usall=cat(2,Us{:})';
    
    
    vals=compute_tr_max_measurement_diff_ut(Usall,tr_id,Tall,my_var_utc,rows(keep),cols(keep),ntr);
    keep_on=vals>0;
    Cols{cnt}=cols(keep(keep_on));
    Rows{cnt}=rows(keep(keep_on));
    Vals{cnt}=vals(keep_on).*vals_euc(keep(keep_on));
    rows(keep)=[];
    cols(keep)=[];
    my_var_utc=(max_aggr^2/aggr^2)*my_var_ut;
end
A=sparse(cat(1,Rows{:}),cat(1,Cols{:}),cat(1,Vals{:}),ntr,ntr);





end

