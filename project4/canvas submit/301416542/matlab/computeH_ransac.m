function [ bestH2to1, inliers,bestRPoints] = computeH_ransac( locs1, locs2)
    %COMPUTEH_RANSAC A method to compute the best fitting homography given a
    %list of matching points.

    %Q2.2.3
    
    count = size(locs1,1);
    %iterations = 10000;
    iterations = 30000;
    inliers=0;
    tempInliers=[];
    bestH2to1=[];
    inliersCount=0;
    inliersCountMax=0;
    normDis = 0.4;
    groupSize=4;
    bestRPoints = [];


    for i= 1:iterations
        inliersCount=0;
        tempInliers=[];
        if count < 4
            randIdx = randperm(count,count);
            randPoints1 = [ locs1(randIdx,1),locs1(randIdx,2),ones(count,1);];
            randPoints2 = [ locs2(randIdx,1),locs2(randIdx,2),ones(count,1);];
        else
            randIdx = randperm(count,groupSize);
            randPoints1 = [ locs1(randIdx,1),locs1(randIdx,2),ones(groupSize,1);];
            randPoints2 = [ locs2(randIdx,1),locs2(randIdx,2),ones(groupSize,1);];
        end
        tempH = computeH_norm(randPoints1,randPoints2);
        
        for j =1:count
            temp=[locs1(j,1) locs1(j,2) 1]';
            result = tempH*temp;
            x_H = result(1,1)/result(3,1);
            y_H = result(2,1)/result(3,1);
            points_pred=[x_H y_H];
            points_real=[locs2(j,1) locs2(j,2) 1];
            dis=sqrt( (points_real(1)-points_pred(1)).^2 + (points_real(2)-points_pred(2)).^2 );
            if dis<normDis
                inliersCount = inliersCount + 1;
                tempInliers = [tempInliers,1];
            else
                tempInliers = [tempInliers,0];
            end
        end

        if inliersCount > inliersCountMax
            bestH2to1 = tempH;
            inliersCountMax = inliersCount;
            inliers = tempInliers;
            bestRPoints = [ locs1(randIdx,1),locs1(randIdx,2);];

        end
    end
end

