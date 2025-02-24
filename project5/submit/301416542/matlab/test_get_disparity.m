clear all;
close all;

% Load image and paramters
im1 = imread('../data/im1.png');
im2 = imread('../data/im2.png');
im1 = rgb2gray(im1);
im2 = rgb2gray(im2);

maxDisp = 20; 
windowSize = 3;


mask = ones(windowSize,windowSize);
[height, width] = size(im2);

im1_w = conv2(im1,mask,'same');
%imshow(im1_w);

disp_all = zeros(height, width,maxDisp+1);

for d = 0:maxDisp
    shifted_im2 = circshift(im2,d,2);
    im2_w = conv2(shifted_im2,mask,'same');
    
    dis = (im1_w - im2_w).^2;
    disp_all(:,:,d+1)=dis;
end

[M,I] = min(disp_all,[],3);
dispM = I;

figure; imagesc(dispM.*(im1>40)); colormap(gray); axis image;

