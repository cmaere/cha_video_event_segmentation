 function Nr=getNumberRegions(region_maps)
        Nr=zeros(length(region_maps),1);
        for l=1:length(region_maps)
            Nr(l)=max(max(region_maps{l}));
        end
    end