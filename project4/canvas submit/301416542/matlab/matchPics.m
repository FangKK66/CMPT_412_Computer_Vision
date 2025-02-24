function [ locs1, locs2] = matchPics( I1, I2 )
%MATCHPICS Extract features, obtain their descriptors, and match them!

%% Convert images to grayscale, if necessary
if size(I1,3) == 3
    I1 = rgb2gray(I1);
end

if size(I2,3) == 3
    I2 = rgb2gray(I2);
end
useSURF = 1;
%% Detect features in both images
if useSURF==0
    point1 = detectFASTFeatures(I1);
    point2 = detectFASTFeatures(I2);
else
    point1 = detectSURFFeatures(I1);
    point2 = detectSURFFeatures(I2);
end

%% Obtain descriptors for the computed feature locations


if useSURF==0
    [desc1, locs1] = computeBrief(I1, point1.Location);
    [desc2, locs2] = computeBrief(I2, point2.Location);
else
    [desc1, locs1] = extractFeatures(I1, point1,'Method', 'SURF');
    [desc2, locs2] = extractFeatures(I2, point2,'Method', 'SURF');
end

%% Match features using the descriptors
%indexPairs = matchFeatures(desc1,desc2,'MatchThreshold', 10);
%indexPairs = matchFeatures(desc1,desc2,'MatchThreshold', 10,'MaxRatio',0.69);
if useSURF==0
    indexPairs = matchFeatures(desc1,desc2,'MatchThreshold', 10,'MaxRatio',0.68);
else
    indexPairs = matchFeatures(desc1,desc2,'MatchThreshold', 10,'MaxRatio',0.4);
end

%% Visualize
%Reference: https://www.mathworks.com/help/vision/ref/matchfeatures.html
if useSURF==0
    mp1 = locs1(indexPairs(:,1),:);
    mp2 = locs2(indexPairs(:,2),:);
else
    mp1 = double(locs1(indexPairs(:,1),:).Location);
    mp2 = double(locs2(indexPairs(:,2),:).Location);
%showMatchedFeatures(I1, I2, mp1, mp2,'montage')

%saveas(gcf,'../results/4_1_NonMR.jpg');
%saveas(gcf,'../results/4_1_MR.jpg');

locs1 = mp1;
locs2 = mp2;

end

