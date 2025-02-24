% Your solution to Q2.1.5 goes here!
clear all;
close all;

%% Read the image and convert to grayscale, if necessary
img = imread('../data/cv_cover.jpg');
if size(img,3) == 3
    img = rgb2gray(img);
end
%% Compute the features and descriptors
point1_fast = detectFASTFeatures(img);
[desc1_fast, locs1_fast] = computeBrief(img, point1_fast.Location);

point1_surf = detectSURFFeatures(img);
[features_surf,vp_surf] = extractFeatures(img, point1_surf,'Method', 'SURF');

his_fast=[];
his_surf=[];
path0='../results/4_2_';
path1='../results/4_2_Rotate_';
path2_fast='_fast.jpg';
path2_surf='_surf.jpg';

for i = 0:36
    %% Rotate image
    img_R = imrotate(img,i*10);
    
    %% Compute features and descriptors
    %FAST
    point1_fast_R = detectFASTFeatures(img_R);
    [desc1_fast_R, locs1_fast_R] = computeBrief(img_R, point1_fast_R.Location);

    %SURF
    point1_surf_R = detectSURFFeatures(img);
    [features_surf_R,vp_surf_R] = extractFeatures(img_R, point1_surf_R,'Method', 'SURF');
    
    %% Match features
    %FAST
    indexPairs_fast = matchFeatures(desc1_fast,desc1_fast_R,'MatchThreshold', 10,'MaxRatio',0.72);
    
    %SURF
    indexPairs_surf = matchFeatures(features_surf,features_surf_R,'MatchThreshold', 10,'MaxRatio',0.72);
    
    %% Update histogram
    count_fast = size(indexPairs_fast,1);
    count_surf = size(indexPairs_surf,1);
    his_fast = [his_fast,count_fast];
    his_surf = [his_surf,count_surf];
    

    %% Visualize three different orientation
    if i==0 || i==5 || i== 16 || i== 27
        degree = i*10;
        temp = num2str(degree);

        mp1_fast = locs1_fast(indexPairs_fast(:,1),:);
        mp2_fast = locs1_fast_R(indexPairs_fast(:,2),:);
        showMatchedFeatures(img, img_R, mp1_fast, mp2_fast,'montage')
        path = [path1 temp path2_fast];
        saveas(gcf,path);
        figure()

        mp1_surf = vp_surf(indexPairs_surf(:,1),:);
        mp2_surf = vp_surf_R(indexPairs_surf(:,2),:);
        showMatchedFeatures(img, img_R, mp1_surf, mp2_surf,'montage')
        path = [path1 temp path2_surf];
        saveas(gcf,path);
        figure()
    end
    

end

%% Display histogram
x = 0:10:360;
temp2 = 'his';

bar(x,his_fast)
path = [path0 temp2 path2_fast];
saveas(gcf,path);
figure()


bar(x,his_surf)
path = [path0 temp2 path2_surf];
saveas(gcf,path);


%figure()
%h = histogram(his_surf);
