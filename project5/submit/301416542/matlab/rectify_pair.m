function [M1, M2, K1n, K2n, R1n, R2n, t1n, t2n] = ...
                        rectify_pair(K1, K2, R1, R2, t1, t2)
% RECTIFY_PAIR takes left and right camera paramters (K, R, T) and returns left
%   and right rectification matrices (M1, M2) and updated camera parameters. You
%   can test your function using the provided script q4rectify.m

%% 1. Compute the optical center c1 and c2 of each camera by c = −(KR)^{−1}(Kt).
c1 = -(K1*R1)^(-1) * (K1*t1);
c2 = -(K2*R2)^(-1) * (K2*t2);


%% 2. Compute the new rotation matrix where r1 , r2 , r3 ∈ R3×1 are 
% orthonormal vectors that represent x-, y-, and z-axes of the camera reference frame,respectively.

% a. The new x-axis (r1) is parallel to the baseline: r1 = (c1 − c2)/∥c1 − c2∥.
r1 = (c1 - c2) / norm(c1 - c2);

% b. The new y-axis (r2) is orthogonal to x and to any arbitrary unit vector, which we
% set to be the z unit vector of the old left matrix: r2 is the cross product of R1(3, :)
% and r1.
r2 = cross(R1(3,:),r1);
r2_2 = cross(R2(3,:),r1);
% c. The new z-axis (r3) is orthogonal to x and y: r3 is the cross product of r2 and r1
r3 = cross(r2,r1);
r3_2 = cross(r2_2,r1);
R_1=[r1';r2;r3];
R_2=[r1';r2_2;r3_2];
R1n = R_1;
R2n = R_2;

%% 3. Compute the new intrinsic parameter K`. We can use an arbitrary one. In our test code,
% we just let K`= K2.
K1n = K2;
K2n = K2;


%% 4. Compute the new translation
t1n = -R_1*c1;
t2n = -R_2*c2;

%% 5. Finally, the rectification matrix of the first camera can be obtained by
% M1 = (K1n * R1n)*(K1*R1)^(-1);
M1 = (K1n * R1n)*(K1*R1)^(-1);
M2 = (K2n * R2n)*(K2*R2)^(-1);


