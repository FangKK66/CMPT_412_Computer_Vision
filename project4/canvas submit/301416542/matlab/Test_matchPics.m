clear all;
close all;

I1 = imread('../data/cv_cover.jpg');
I2 = imread('../data/cv_desk.png');

[ locs1, locs2] = matchPics( I1, I2 );