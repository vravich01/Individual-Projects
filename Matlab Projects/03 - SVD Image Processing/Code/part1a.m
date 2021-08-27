%%Header
figure;
hold on;
format long;
load("data.mat");

%%Images
subplot(1, 2, 1);
imshow(A);
title({'Original Image (A)'});
subplot(1, 2, 2);
imshow(An);
title({'Noisy Image (A_n)'});