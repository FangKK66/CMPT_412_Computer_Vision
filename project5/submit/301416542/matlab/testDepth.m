clear all ;
% Load image and paramters
im1 = imread('../data/im1.png');
im2 = imread('../data/im2.png');
im1 = rgb2gray(im1);
im2 = rgb2gray(im2);
load('rectify.mat', 'M1', 'M2', 'K1n', 'K2n', 'R1n', 'R2n', 't1n', 't2n');

maxDisp = 20; 
windowSize = 3;
dispM = get_disparity(im1, im2, maxDisp, windowSize);

% --------------------  get depth map

depthM = get_depth(dispM, K1n, K2n, R1n, R2n, t1n, t2n);


% --------------------  Display

figure; imagesc(dispM.*(im1>40)); colormap(gray); axis image;
figure; imagesc(depthM.*(im1>40)); colormap(gray); axis image;


[JL, JR, bbL, bbR] = warp_stereo(im1,im2,M1,M2);
%figure; imshow(JL);
%figure; imshow(JR);
JL_cut = JL(17:656,444:923);
JR_cut = JR(17:656,6:485);
%figure; imshow(JL_cut);
dispM_R = get_disparity(JL_cut, JR_cut, maxDisp, windowSize);
depthM_R = get_depth(dispM_R, K1n, K2n, R1n, R2n, t1n, t2n);
figure; imagesc(dispM_R.*(JL_cut>40)); colormap(gray); axis image;
figure; imagesc(depthM_R.*(JL_cut>40)); colormap(gray); axis image;
