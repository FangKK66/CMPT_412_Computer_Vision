function [H2to1] = computeH_norm(points1, points2)
    count = size(points1,1);
    x1=points1(:,1);
    y1=points1(:,2);
    x2=points2(:,1);
    y2=points2(:,2);

    xy1=[points1(:,1),points1(:,2),ones(count,1);];
    xy2=[points2(:,1),points2(:,2),ones(count,1);];

    %% Compute centroids of the points
    centroid1 = [sum(x1,1)/count sum(y1,1)/count];
    centroid2 = [sum(x2,1)/count sum(y2,1)/count];

    %% Shift the origin of the points to the centroid
    %x1=x1-centroid1(1);
    %y1=y1-centroid1(2);
    %x2=x2-centroid2(1);
    %y2=y2-centroid2(2);
    
    shif1=[1 0 -centroid1(1);0 1 -centroid1(2); 0 0 1;];
    shif2=[1 0 -centroid2(1);0 1 -centroid2(2); 0 0 1;];
    
    
    %% Normalize the points so that the average distance from the origin is equal to sqrt(2).
    avgDis1x=sqrt(2)/centroid1(1);
    avgDis1y=sqrt(2)/centroid1(2);
    avgDis2x=sqrt(2)/centroid2(1);
    avgDis2y=sqrt(2)/centroid2(2);

    scale1=[avgDis1x 0 0;0 avgDis1y 0; 0 0 1;];
    scale2=[avgDis2x 0 0;0 avgDis2y 0; 0 0 1;];

    %% similarity transform 1
    T1 = scale1*shif1;
    
    %% similarity transform 2
    T2 = scale2*shif2;

    %% Compute Homography

    points1_N = T1*xy1.';
    points1_N = transpose(points1_N);
    points2_N = T2*xy2.';
    points2_N = transpose(points2_N);
    H2to1_N = computeH( points1_N, points2_N );

    
    %% Denormalization
    H2to1 = T2\H2to1_N*T1;

end