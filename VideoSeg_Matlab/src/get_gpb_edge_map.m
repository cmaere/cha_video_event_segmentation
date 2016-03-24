function [ucm_map]=get_gpb_edge_map(pb_file,imfile)

%pb_file = fullfile(pb_dir, [fname, '_pb.mat']);
if ~exist(pb_file, 'file')
    opb = globalPb(imfile, '', 0.1);
    if ~isempty(pb_file)
        save(pb_file, 'opb');
    end
end

q=load(pb_file);
if isfield(q,'opb')
    opb=q.opb;
elseif isfield(q,'gPb_orient')
    opb=q.gPb_orient;
end
if isfield(q,'ucm_map')
    ucm_map=q.ucm_map;
else
    [~,orient_map]=max(opb,[],3);
    if max(max(max(opb)))>2
        
    else
        opb=uint8(255*opb);
        
    end
    ucm_map = double(contours2ucm(opb,'imageSize'));
    ucm_map(2:end, 2:end) = ucm_map(1:end-1, 1:end-1);
    orient_map(2:end, 2:end) = orient_map(1:end-1, 1:end-1);
    
    save(pb_file,'opb','ucm_map','orient_map');
end
end

%end
