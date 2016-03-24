function colors=map2jet(value)
w=colormap(jet);

value=(size(w,1)-1)*value/(max(value));
value=round(value);
value=value+1;


colors=w(value,:);