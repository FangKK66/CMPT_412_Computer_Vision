clear all;
close all;

cv_img = imread('../data/cv_cover.jpg');
desk_img = imread('../data/cv_desk.png');

[locs1, locs2] = matchPics(cv_img, desk_img);
[ bestH2to1, inliers,bestRPoints] = computeH_ransac( locs1, locs2);
count = size(locs1,1);
points = [];
points_P=[];
for i = 1:count
    if inliers(i)==1
        point = [locs1(i,1) locs1(i,2)];
        points = [points;point];

        temp1=[locs1(i,1) locs1(i,2) 1]';
        result = bestH2to1*temp1;
        x_P = result(1,1)/result(3,1);
        y_P = result(2,1)/result(3,1);
        point_P=[x_P y_P];
        points_P=[points_P;point_P];
    end
end

figure()
imshow(cv_img);
hold on;
plot(bestRPoints(:,1), bestRPoints(:,2), 'r*', 'LineWidth', 0.5, 'MarkerSize', 7);
saveas(gcf,'../results/4_5_O.jpg');


figure()
showMatchedFeatures(cv_img, desk_img, points, points_P,'montage')
saveas(gcf,'../results/4_5_Hr.jpg');

