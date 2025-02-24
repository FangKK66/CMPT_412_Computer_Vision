function [ H2to1 ] = computeH( points1, points2 )
%COMPUTEH Computes the homography between two sets of points
    count = size(points1,1);
    x1=points1(:,1);
    y1=points1(:,2);
    x2=points2(:,1);
    y2=points2(:,2);
    pH=[];
    for idx = 1:count
        p1 = [-x1(idx) -y1(idx) -1 0 0 0 x1(idx)*x2(idx) y1(idx)*x2(idx) x2(idx)];
        p2 = [0 0 0 -x1(idx) -y1(idx) -1 x1(idx)*y2(idx) y1(idx)*y2(idx) y2(idx)];
        pH = [pH;p1;p2];
    end

    [U,S,V] = svd(pH);
    Vy=size(V,2);
    lastV=V(:,Vy);
    H2to1 = reshape(lastV,3,3);
    H2to1 = H2to1';
end
