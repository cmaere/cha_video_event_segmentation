function [Ix, Iy] = gaussDeriv_dir(I)
%function [Ix, Iy] = gaussDeriv_dir(I, para,omega)
% taking the derivation with [-1 0 1] and then do gaussian smoothing
% if para.deriv_old
%     if nargin < 2
%         omega = 0.8;
%     end
%     
%     k = [-1 0 1];
%     
%     Ix_unsmooth = imfilter(I, k, 'replicate');
%     Iy_unsmooth = imfilter(I, k', 'replicate');
%     
%     Ix = gaussSmooth_dir(Ix_unsmooth, omega);
%     Iy = gaussSmooth_dir(Iy_unsmooth, omega);
% else
    k = (1/12)*[1 -8 0 8 1];
    
    Ix = imfilter(I, k, 'replicate');
    Iy = imfilter(I, k', 'replicate');
% end