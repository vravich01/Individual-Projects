%%Header
figure;
hold on;
format long;
load("deblur.mat");

%%Set up
dimen = 64;

%%Computation
xNaive = A \ bn;

%%Results
subplot(1,2,1);
imshow(reshape(xtrue, [dimen, dimen]));
title({'Original Image (x_t)'});
subplot(1,2,2);
imshow(reshape(xNaive, [dimen, dimen]));
title({'Naive Solution'});