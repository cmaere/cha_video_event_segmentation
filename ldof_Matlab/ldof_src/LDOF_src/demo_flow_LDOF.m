function chancy_ldf=demo_flow_LDOF(img1,img2,imnames,para)

imfile1=img1;
imfile2=img2;


im1=imread(imfile1);
im2=imread(imfile2);

verbose=0;
[p,q,~]=size(im1);
para=get_para_flow(p,q);


[F,c1,c2]=LDOF(imfile1,imfile2,para,verbose);

% check_flow_correspondence(im1,im2,F);
flow_warp(im1,im2,F,1)
flow_view=flowToColor(F);
imwrite(flow_view,[para.video_dir get_image_name(imnames(t).name) 'LDOF.flo'],'flo');
end
