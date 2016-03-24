function B=sparse_blkmat(A,Nr)
%inpt:cell array of sparse sqyuare matrices
cntr=0;
k=0;
for i=1:size(A,1)-1
    cntc=0;
    for j=1:size(A,2)
        if isempty(A{i,j})
             cntc=cntc+Nr(j);
             continue;
        end
        k=k+1;
        [is{k},js{k},vals{k}]=find(A{i,j});
        is{k}=is{k}+cntr;
        js{k}=js{k}+cntc;
        cntc=cntc+size(A{i,j},2);
    end
    cntr=cntr+Nr(i);
end
n=max(size(A,1),size(A,2));
B=sparse(cat(1,is{:}),cat(1,js{:}),cat(1,vals{:}),sum(Nr(1:n)),...
    sum(Nr(1:n)));
B=max(B,B');