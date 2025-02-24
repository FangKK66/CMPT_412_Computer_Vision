function dispM = get_disparity(im1, im2, maxDisp, windowSize)
% GET_DISPARITY creates a disparity map from a pair of rectified images im1 and
%   im2, given the maximum disparity MAXDISP and the window size WINDOWSIZE.

mask = ones(windowSize,windowSize);
[row, col] = size(im2);

im1_w = conv2(im1,mask,'same');
%imshow(im1_w);

disp_all = zeros(row, col,maxDisp+1);

for d = 0:maxDisp
    shifted_im2 = circshift(im2,d,2);
    im2_w = conv2(shifted_im2,mask,'same');
    
    dis = (im1_w - im2_w).^2;
    disp_all(:,:,d+1)=dis;
end

[M,I] = min(disp_all,[],3);
dispM = I;

dispM =dispM-1;

