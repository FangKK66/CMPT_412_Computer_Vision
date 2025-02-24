function depthM = get_depth(dispM, K1, K2, R1, R2, t1, t2)
% GET_DEPTH creates a depth map from a disparity map (DISPM).


% depthM(y, x) = b × f /dispM(y, x)
% b = ∥c1 − c2∥
% f = K1(1, 1)
% let depthM(y, x) = 0 whenever dispM(y, x) = 0 to avoid dividing by 0.

[h,w] = size(dispM);
depthM = zeros(h,w);

c1 = -(K1*R1)^(-1) * (K1*t1);
c2 = -(K2*R2)^(-1) * (K2*t2);

b = norm(c1 - c2);
f = K1(1, 1);

for idx1 = 1:h
    for idx2 = 1:w
        if dispM(idx1,idx2) ~= 0
            depthM(idx1,idx2) = b * f / dispM(idx1,idx2);
        end
    end
end