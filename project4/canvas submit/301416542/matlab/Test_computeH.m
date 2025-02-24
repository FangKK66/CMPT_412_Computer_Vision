clear all;
close all;

I1 = imread('../data/cv_cover.jpg');
I2 = imread('../data/cv_desk.png');

[points1,points2] = matchPics(I1,I2);
H2to1 = computeH( points1, points2 );

[h,w]=size(I1);
points=[];
for i = 1:10
    point_x = randi(w);
    point_y = randi(h);
    new_p = [point_x point_y];
    points=[points;new_p];
end
points_H=[];
for i =1:10
    temp=[points(i,1) points(i,2) 1]';
    result = H2to1*temp;
    x_H = result(1,1)/result(3,1);
    y_H = result(2,1)/result(3,1);
    p=[x_H y_H];
    points_H=[points_H;p];
end
figure()
imshow(I1);
hold on;
plot(points(:,1), points(:,2), 'r*', 'LineWidth', 0.5, 'MarkerSize', 5);
saveas(gcf,'../results/4_3_O.jpg');

figure()
showMatchedFeatures(I1, I2, points, points_H,'montage')
saveas(gcf,'../results/4_3_H.jpg');