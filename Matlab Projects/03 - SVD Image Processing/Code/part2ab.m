%%Header
figure;
hold on;
format long;
load("deblur.mat");

%%Set up
dimen = 64;

%%Results
subplot(1,3,1);
imshow(reshape(xtrue, [dimen, dimen]));
title({'Original Image (x_t)'});
subplot(1,3,2);
imshow(reshape(b, [dimen, dimen]));
title({'Blurry Image (b)'});
subplot(1,3,3);
imshow(reshape(bn, [dimen, dimen]));
title({'Blurry and Noisy Image (b_n)'});