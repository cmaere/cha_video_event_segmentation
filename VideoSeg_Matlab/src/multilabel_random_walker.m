function [labels,potentials,maxpot]=multilabel_random_walker(L,seeds,U)
% adapting Leo Grady's code %
n=length(L);
nlabels=size(U,2);
nonseeds=[1:n]';
nonseeds(seeds)=[];
b=-L(nonseeds,seeds)*(U);
x=L(nonseeds,nonseeds)\b;
potentials=zeros(n,nlabels);
potentials(seeds,:)=U;
potentials(nonseeds,:)=x;
[maxpot,labels]=max(potentials,[],2);


