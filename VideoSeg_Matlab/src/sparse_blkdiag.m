function B=sparse_blkdiag(A)
%inpt:cell array of sparse sqyuare matrices
cnt=0;
for i=1:length(A)
    [is{i},js{i},vals{i}]=find(A{i});
    is{i}=is{i}+cnt;
    js{i}=js{i}+cnt;
    cnt=cnt+size(A{i},1);
end

B=sparse(cat(1,is{:}),cat(1,js{:}),cat(1,vals{:}),cnt,cnt);