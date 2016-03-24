function computeFlowLDOF(imnames,para)
generate_ppm(imnames,para);
video_dir=[fileparts(imnames(1).name) '/'];
para.video_dir=video_dir;
for t=1:length(imnames)-1
     imfile1_ppm=[para.video_dir get_image_name(imnames(t).name) '.ppm'];
     imfile2_ppm=[para.video_dir get_image_name(imnames(t+1).name) '.ppm'];
   
    if (~exist([para.flow_dir 'Forward'...
            get_image_name(imnames(t).name) 'LDOF.flo'],'file'))
        progress(sprintf('\t compute flow'),t, length(imnames)-1);
        system(['./ldof ' imfile1_ppm ' ' imfile2_ppm]);
        movefile([para.video_dir get_image_name(imnames(t).name) 'LDOF.flo'],...
            [para.flow_dir 'Forward' get_image_name(imnames(t).name) 'LDOF.flo']);
        movefile([para.video_dir get_image_name(imnames(t).name) 'LDOF.ppm'],...
            [para.flow_dir 'Forward' get_image_name(imnames(t).name) 'LDOF.ppm']);
    end
    if   (~exist([para.flow_dir 'Backward'...
            get_image_name(imnames(t).name) 'LDOF.flo'],'file'))
        system(['./ldof ' imfile2_ppm ' ' imfile1_ppm]);
        movefile([para.video_dir get_image_name(imnames(t+1).name) 'LDOF.flo'],...
            [para.flow_dir 'Backward' get_image_name(imnames(t).name) 'LDOF.flo']);
        movefile([para.video_dir get_image_name(imnames(t+1).name) 'LDOF.ppm'],...
            [para.flow_dir 'Backward' get_image_name(imnames(t).name) 'LDOF.ppm']);
    end
end

delete_ppm(imnames,para);


    function generate_ppm(imnames,para)
        
        if ~strcmp(para.extension,'ppm')
            for id = 1: length(imnames)
                imname = imnames(id).name;
                [video_dir, imstem]=fileparts(imname);
                img=imread(imname);
                imwrite(img,[video_dir '/' imstem '.ppm'],'ppm');
            end
        end
    end

    function delete_ppm(imnames,para)
        if ~strcmp(para.extension,'ppm')
            for id = 1: length(imnames)
                imname = imnames(id).name;
                [video_dir, imstem]=fileparts(imname);
                if exist([video_dir '/' imstem 'ppm'],'file')
                    delete([video_dir '/' imstem 'ppm']);
                end
            end
        end
    end
end
