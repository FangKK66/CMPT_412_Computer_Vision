

load('../data/intrinsics.mat')
load('../data/someCorresp.mat');
im1 = imread('../data/im1.png');
im2 = imread('../data/im2.png');

F = eightpoint(pts1, pts2, M);

E = essentialMatrix(F, K1, K2);
E