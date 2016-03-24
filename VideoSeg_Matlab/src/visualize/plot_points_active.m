function plot_points_active(f,img,figno)
%finding the indices of feature locations
%f is 2 X N:feature locations
%line_inds=[];
%plots the lines in the cell lines and shows the number when you cklick on them
%and returns the numbers
%if strcmp(col,'rand')
if nargin>2
    figure(figno),
end
imshow(img)
hold on;
plot(f(1,:),f(2,:),'*g')
%  for jj=1:size(f,2)
%  plot(f(1,jj),f(2,jj),'*g')
%  hold on;
%  end
hold on;
% Check whether we need to expand bounds


h=gcf;
set(gca,'UserData',f);
set(h, 'WindowButtonDownFcn', @callback_click);
%line_inds_clicked=get(gca,'UserData');
    function callback_click(src, event);

        pt = get(gca, 'CurrentPoint');
        pt=pt(1,:);
        plot(pt(1),pt(2),'*b');
        hold on;
        selectionType = get(gcf, 'SelectionType');
        f=get(gca,'UserData');
        pts=f';
        [minimum,minindex]=min((pts(:,1)-pt(1,1)).^2+(pts(:,2)-pt(1,2)).^2);
        pt=pts(minindex,:);
        plot(pt(1),pt(2),'*k');
        hold on;
        string=sprintf('%d',minindex);
        text(pt(1),pt(2),string,'BackgroundColor',[.7 .9 .7]);

        % For model pt selection
        %  if (strcmp(selectionType, 'normal'))
        %       for i=1:size(edgelist,2)

        %              if ismember(pt,edgelist{i},'rows')
        %                  i
        %                  %i found corresponding line segment
        %                  a=edgelist{i};
        %                  hold on;
        %                  plot(a(:,1),a(:,2),'gs','MarkerSize', 3);
        %                  hold on;
        %                  text(a(1,1),a(1,2),sprintf('%d',i),'BackgroundColor',[.7 .9 .7]);
        %                  line_inds_clicked=get(gca,'UserData');
        %                  line_inds=[line_inds_clicked;i];
        %  if ishandle(figno2) close(figno2); end
        %  figure(figno2),
        %  plot(features(:,i));
        %  hold off;
        %                  set(gca,'UserData',line_inds);
        %                  break;
        %              end
        %  end
        % end
    end

%   h2 = plot(x(pixel_order{contour_id}), y(pixel_order{contour_id}), 'gs', 'MarkerSize', 6);
%             h1 = plot(sx, sy, 'r*', 'MarkerSize', 10, 'LineWidth', 2);
%             %             title(sprintf('Frame %d: eig %d, loop id=%d, [x,y]=[%d,%d]', ...
%             %                 frame_id, jj, loop_id, sx, sy));
%
%             title(sprintf('Frame %d: contour id=%d, [x,y]=[%d,%d]', ...
%                 frame_id, contour_id, sx, sy));

end
