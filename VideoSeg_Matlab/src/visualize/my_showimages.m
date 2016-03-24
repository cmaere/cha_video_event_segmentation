function h=my_showimages(R,figno)
[p,q]=size(R{1});
n=length(R);
n1=ceil(sqrt(n));
n2=ceil(sqrt(n));
A=zeros(n1*p,n2*q);
cnt=0;
for i=1:n1
    for j=1:n2
        cnt=cnt+1;
        if cnt>length(R) break; end
        A(p*(i-1)+1:p*(i-1)+p,q*(j-1)+1:q*(j-1)+q)=R{cnt};
    end
end

h=figure(figno);clf;
imagesc(A);

end
