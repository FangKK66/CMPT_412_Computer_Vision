load('../data/someCorresp.mat');
I1 = imread('../data/im1.png');
I2 = imread('../data/im2.png');


% %% Normalize points
% p1_s = pts1 ./M;
% p2_s = pts2 ./M;
% 
% %% Construct the M x 9 matrix A
% A=[];
% for idx = 1:size(p1_s,1)
%     A=[A; p2_s(idx,1)*p1_s(idx,1), p2_s(idx,1)*p1_s(idx,2), p2_s(idx,1), ...
%         p2_s(idx,2)*p1_s(idx,1), p2_s(idx,2)*p1_s(idx,2), p2_s(idx,2), ...
%         p1_s(idx,1), p1_s(idx,2), 1];
% end
% 
% %% Find the SVD of A
% [U,S,V] = svd(A);
% 
% 
% %% Entries of Fare the elements of column of Vcorresponding to the least singular value
% F = V(:,9);
% F = reshape(F,3,3);
% F = F';
% 
% %% Enforce rank 2 constraint on F
% [u,s,v] = svd(F);
% s(3,3)=0;
% F=u*s*v';
% 
% %% Un-normalize F
% unScaleM=[1/M 0 0; 0 1/M 0; 0 0 1];
% F = unScaleM' * F * unScaleM;
% F
F = eightpoint(pts1, pts2, M);
F
displayEpipolarF(I1,I2,F);





