function F = eightpoint(pts1, pts2, M)
    % eightpoint:
    %   pts1 - Nx2 matrix of (x,y) coordinates
    %   pts2 - Nx2 matrix of (x,y) coordinates
    %   M    - max (imwidth, imheight)

    % Q2.1 - Todo:
    %     Implement the eightpoint algorithm
    %     Generate a matrix F from correspondence '../data/some_corresp.mat'

    %% Normalize points
    p1_s = pts1 ./M;
    p2_s = pts2 ./M;
    unScaleM=[1/M 0 0; 0 1/M 0; 0 0 1];

    %% Construct the M x 9 matrix A
    A=[];
    for idx = 1:size(p1_s,1)
        A=[A; p2_s(idx,1)*p1_s(idx,1), p2_s(idx,1)*p1_s(idx,2), p2_s(idx,1), ...
            p2_s(idx,2)*p1_s(idx,1), p2_s(idx,2)*p1_s(idx,2), p2_s(idx,2), ...
            p1_s(idx,1), p1_s(idx,2), 1];
    end

    %% Find the SVD of A
    % Entries of Fare the elements of column of Vcorresponding to the least singular value
    [U,S,V] = svd(A);

    F = V(:,9);
    F = reshape(F,3,3);
    F = F';
    
    %% Enforce rank 2 constraint on F
    [u,s,v] = svd(F);
    s(3,3)=0;
    F=u*s*v';

    %% Un-normalize F
    F = unScaleM' * F * unScaleM;
    %F
end