% compute globalPb from sPb and cues
function [gPb_orient] = gPb_from_cues(bg1, bg2, bg3, cga1, cga2, cga3, cgb1, cgb2, cgb3, tg1, tg2, tg3, sPb)

weights = [ 0   0    0.0028    0.0041    0.0042    0.0047    0.0033    0.0033    0.0035    0.0025    0.0025    0.0137    0.0139];

gPb_orient = zeros(size(tg1));
for o = 1 : size(gPb_orient, 3),
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

    sc = weights(13)*sPb(:, :, o);

    gPb_orient(:, :, o) = l1 + a1 + b1 + t1 + l2 + a2 + b2 + t2 + l3 + a3 + b3 + t3 + sc;
end

for o = 1 : 8,
    gPb_orient(:, :, o) = normalize_output(gPb_orient(:, :, o));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
function [pb_norm] = normalize_output(pb)

[tx, ty] = size(pb);
pb_norm = max(0, min(1, 1.2*pb));

%contrast change with sigmoid 
beta = [-2.6433; 10.7998];
pb_norm = pb_norm(:);
x = [ones(size(pb_norm)) pb_norm]';
pb_norm = 1 ./ (1 + (exp(-x'*beta)));
pb_norm = (pb_norm-0.0667) / 0.9333;
pb_norm = reshape(pb_norm, [tx ty]);
