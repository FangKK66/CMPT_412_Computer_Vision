clear all;
close all;
% Script for testing Pose Estimation
% Randomly generate camera matrix
K = [1,0,1e2;0,1,1e2;0,0,1];

[R1, ~, ~] = svd(randn(3));
if det(R1) < 0
    R1 = -R1;
end
t = randn(3, 1);

P1 = K*[R1, t];

% Random generate 2D and 3D points
N = 10;
X = randn(3, N);
x = P1*[X; ones(1, N)];
x(1, :) = x(1, :)./x(3, :);
x(2, :) = x(2, :)./x(3, :);
x = x(1:2, :);

% test
PClean = estimate_pose(x, X);
P = PClean;



%% 1. Compute the camera center c by using SVD. 
% Hint: c is the eigenvector corresponding to the smallest eigenvalue.
[U,S,V] = svd(P);
c = V(:,4);
c = [c(1)/c(4);c(2)/c(4);c(3)/c(4);];

R_QR = P(1:3,1:3);
C_1 = -R_QR(3,3)/sqrt(R_QR(3,2)^2+R_QR(3,3)^2);
S_1 =  R_QR(3,2)/sqrt(R_QR(3,2)^2+R_QR(3,3)^2);
Qx = [1 0 0; 0 C_1 -S_1; 0 S_1 C_1;];
R_QR = R_QR*Qx;

C_2 = R_QR(3,3)/sqrt(R_QR(3,1)^2+R_QR(3,3)^2);
S_2 = R_QR(3,1)/sqrt(R_QR(3,1)^2+R_QR(3,3)^2);
Qy = [C_2 0 S_2; 0 1 0; -S_2 0 C_2;];
R_QR = R_QR*Qy;

C_3 = -R_QR(2,2)/sqrt(R_QR(2,1)^2+R_QR(2,2)^2);
S_3 =  R_QR(2,1)/sqrt(R_QR(2,1)^2+R_QR(2,2)^2);
Qz = [C_3 -S_3 0; S_3 C_3 0; 0 0 1;];
R_QR = R_QR*Qz;

Q=(Qx*Qy*Qz)';

if R_QR(1,1)<0
    R_QR(:,1)=R_QR(:,1)*(-1);
    Q(1,:)=Q(1,:)*(-1);
end
if R_QR(2,2)<0
    R_QR(:,2)=R_QR(:,2)*(-1);
    Q(2,:)=Q(2,:)*(-1);
end
if R_QR(3,3)<0
    R_QR(:,3)=R_QR(:,3)*(-1);
    Q(3,:)=Q(3,:)*(-1);
end

R = Q(1:3,1:3);
K = [R_QR(1,1) R_QR(1,2) R_QR(1,3); 0 R_QR(2,2) R_QR(2,3); 0 0 R_QR(3,3);];


%% 2. Compute the intrinsic K and rotation R by using QR decomposition. K is a right upper
%triangle matrix while R is an orthonormal matrix. (See here for a reference
%https://math.stackexchange.com/questions/1640695/rq-decomposition)




%% 3. Compute the translation by t = −Rc.
t = -R*c;