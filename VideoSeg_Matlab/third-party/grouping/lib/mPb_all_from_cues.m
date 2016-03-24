% compute multiscale pb from cues
function [mPb_all mPb_nmax mPb_nmax_rsz] = mPb_all_from_cues(bg1, bg2, bg3, cga1, cga2, cga3, cgb1, cgb2, cgb3, tg1, tg2, tg3, rsz);

weights = [0.0123    0.0110    0.0117    0.0169    0.0176    0.0198    0.0138    0.0138    0.0145    0.0104    0.0105    0.0115];

% compute mPb at full scale
mPb_all = zeros(size(tg1));
for o = 1 : size(mPb_all, 3),
    l1 = weights(1)*bg1(:, :, o);
    l2 = weights(2)*bg2(:, :, o);
    l3 = weights(3)*bg3(:, :, o);

    a1 = weights(4)*cga1(:, :, o);
    a2 = weights(5)*cga2(:, :, o);
    a3 = weights(6)*cga3(:, :, o);

    b1 = weights(7)*cgb1(:, :, o);
    b2 = weights(8)*cgb2(:, :, o);
    b3 = weights(9)*cgb3(:, :, o);

    t1 = weights(10)*tg1(:, :, o);
    t2 = weights(11)*tg2(:, :, o);
    t3 = weights(12)*tg3(:, :, o);

    mPb_all(:, :, o) = l1 + a1 + b1 + t1 + l2 + a2 + b2 + t2 + l3 + a3 + b3 + t3;
end

% non-maximum suppression
mPb_nmax = nonmax_channels(mPb_all);
mPb_nmax = max(0, min(1, 1.2*mPb_nmax));


% compute mPb_nmax resized if necessary
if rsz < 1,
    mPb_all = imresize(tg1, rsz);
    mPb_all(:) = 0;

    for o = 1 : size(mPb_all, 3),
        l1 = weights(1)*bg1(:, :, o);
        l2 = weights(2)*bg2(:, :, o);
        l3 = weights(3)*bg3(:, :, o);

        a1 = weights(4)*cga1(:, :, o);
        a2 = weights(5)*cga2(:, :, o);
        a3 = weights(6)*cga3(:, :, o);

        b1 = weights(7)*cgb1(:, :, o);
        b2 = weights(8)*cgb2(:, :, o);
        b3 = weights(9)*cgb3(:, :, o);

        t1 = weights(10)*tg1(:, :, o);
        t2 = weights(11)*tg2(:, :, o);
        t3 = weights(12)*tg3(:, :, o);

        mPb_all(:, :, o) = imresize(l1 + a1 + b1 + t1 + l2 + a2 + b2 + t2 + l3 + a3 + b3 + t3, rsz);
    end

    mPb_nmax_rsz = nonmax_channels(mPb_all);
    mPb_nmax_rsz = max(0, min(1, 1.2*mPb_nmax_rsz));
else
    mPb_nmax_rsz = mPb_nmax;
end

% rescale mPb_all the same way as mPb_nmax
mPb_all = max(0, min(1, 1.2*mPb_all));
