function [pts2] = epipolarCorrespondence(im1, im2, F, pts1)
% epipolarCorrespondence:
%   Args:
%       im1:    Image 1
%       im2:    Image 2
%       F:      Fundamental Matrix from im1 to im2
%       pts1:   coordinates of points in image 1
%   Returns:
%       pts2:   coordinates of points in image 2
%
pts1_count=size(pts1,1);

window_size = 10;
im1_gray = rgb2gray(im1);
im2_gray = rgb2gray(im2);

width = size(im1,2);
height = size(im1,1);


pts2=[];

for idx=1:pts1_count
    im1_window = double(im1_gray( (pts1(idx,2)-window_size):(pts1(idx,2)+window_size), (pts1(idx,1)-window_size):(pts1(idx,1)+window_size) ));
    v=[pts1(idx,1),pts1(idx,2),1]';
    line = F * v;
    scale = sqrt(line(1)^2+line(2)^2);
    line = line/scale;
    
    lowestS = 10000000000;
    for corrX=1+window_size:width-window_size
        corrY=round(-(line(1) * corrX + line(3))/line(2));
        
        im2_window = double(im2_gray( (corrY-window_size):(corrY+window_size), (corrX-window_size):(corrX+window_size) ));
        
        
        diff= norm(abs(im1_window-im2_window));
        %diff= sqrt(sum((im1_window-im2_window).^2,'all'));
        if diff<lowestS
            lowestS = diff;
            corrX_best=corrX;
            corrY_best=corrY;
        end

    end
    
    %imshow(im1,[]);hold on
    %plot(pts1(1,1),pts1(1,2), '*', 'MarkerSize', 6, 'LineWidth', 2);
    %figure();
    %imshow(im2,[]);hold on
    %plot(corrX_best,corrY_best, '*', 'MarkerSize', 6, 'LineWidth', 2);
    pts2=[pts2;corrX_best,corrY_best];


end
end
