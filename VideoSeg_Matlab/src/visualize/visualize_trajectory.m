function visualize_trajectory(tr,hist,imnames,figno)

%show the trajectories that are between start frame and end frame..
[XYT,Ids,tr]=quick_tr(tr);
T=XYT(3,:);
Cols=jet(length(tr));
if nargin<8
    figno=1;
end

if ishandle(figno); close(figno); end
figure(figno),
for ii=1:length(imnames)
    t=imnames(ii).t;
    ii
    img=imread(imnames(ii).name);
    
    imshow(img)
    hold on;
    trids=unique(Ids(find(T==t)));
    for jj=1:length(trids)
        traj=tr(trids(jj));
        ind=find(traj.XYTPos(3,:)==ii);
        x=traj.XYTPos(1,max([1 ind-hist]):ind);
        y=traj.XYTPos(2,max([1 ind-hist]):ind);
        %         plot(x,y,'.','Color',Cols(trids(jj),:),'MarkerSize',15);
        % plot(x(2:end),y(2:end),'.','Color','k','MarkerSize',15);
        plot(x(1:end),y(1:end),'.','Color',Cols(trids(jj),:),'MarkerSize',15);
        
        hold on;
    end
    title(['frame' num2str(ii)]);
    
    drawnow;
    pause(0.1)
    
end

end






