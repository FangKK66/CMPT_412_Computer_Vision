function P = estimate_pose(x, X)
% ESTIMATE_POSE computes the pose matrix (camera matrix) P given 2D and 3D
% points.
%   Args:
%       x: 2D points with shape [2, N]
%       X: 3D points with shape [3, N]



% X1 Y1 Z1 1 0 0 0 0 −u1*X1 −u1*Y1 −u1*Z1 −u1
% 0 0 0 0 X1 Y1 Z1 1 −v1*X1 −v1*Y1 −v1*Z1 −v1
% https://osf.io/ah8ym/download/?format=pdf#:~:text=The%20camera%20projection%20matrix%20and,points%20across%20the%20two%20images.
% page 9

A =[];
[row,col]=size(x);
if row>col 
    count = row;
else
    count = col;
end

for idx = 1:count
    if row>col
        A_1 = [X(idx,1) X(idx,2) X(idx,3) 1 0 0 0 0 -x(idx,1)*X(idx,1) -x(idx,1)*X(idx,2) -x(idx,1)*X(idx,3) -x(idx,1)];
        A_2 = [0 0 0 0 X(idx,1) X(idx,2) X(idx,3) 1 -x(idx,2)*X(idx,1) -x(idx,2)*X(idx,2) -x(idx,2)*X(idx,3) -x(idx,2)];
    else
        A_1 = [X(1,idx) X(2,idx) X(3,idx) 1 0 0 0 0 -x(1,idx)*X(1,idx) -x(1,idx)*X(2,idx) -x(1,idx)*X(3,idx) -x(1,idx)];
        A_2 = [0 0 0 0 X(1,idx) X(2,idx) X(3,idx) 1 -x(2,idx)*X(1,idx) -x(2,idx)*X(2,idx) -x(2,idx)*X(3,idx) -x(2,idx)];
    end
    A = [A;A_1;A_2;];

end

[U,S,V] = svd(A);
P = V(:,end);
P = reshape(P,[4 3]);
P = P';



