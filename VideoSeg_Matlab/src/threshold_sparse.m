function B=threshold_sparse(A,th)
[n,m]=size(A);
[i,j,k]=find(A);
keep=k>th;
B=sparse(i(keep),j(keep),k(keep),n,m);