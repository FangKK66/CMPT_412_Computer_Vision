% A test script using templeCoords.mat
%
% Write your code here
%
clear all;
close all;
load('../data/intrinsics.mat');
load('../data/someCorresp.mat');
im1 = imread('../data/im1.png');
im2 = imread('../data/im2.png');

F = eightpoint(pts1, pts2, M);
E = essentialMatrix(F, K1, K2);

load('../data/templeCoords.mat');


P1=[1 0 0 0; 0 1 0 0; 0 0 1 0;];
P1_K = K1*P1;

P2_C = camera2(E);

[pts2]=epipolarCorrespondence(im1,im2,F,pts1);

count_Max = 0;

for i =1:size(P2_C,3)
    
    P2 = P2_C(:,:,i);
    P2_K = K2*P2;
    [pts3d,e1,e2] = triangulate(P1_K, pts1, P2_K, pts2);
    

    %find the best camera matrix candidates
    count_temp = 0;
    for j = 1:size(pts3d,1)
        if pts3d(j,3)>0
            count_temp = count_temp+1;
        end
    end

    if count_temp>count_Max
        count_Max = count_temp;
        P2_best = P2;
        P2_K_best = P2_K;
        pts3d_best = pts3d;
    end

end

plot3(pts3d_best(:,1),pts3d_best(:,2),pts3d_best(:,3),'.',MarkerSize=15)
axis equal

R1=P1(:,1:3);
R2=P2_best(:,1:3);
t1=P1(:,4);
t2=P2_best(:,4);

% save extrinsic parameters for dense reconstruction
save('../data/extrinsics.mat', 'R1', 't1', 'R2', 't2');
