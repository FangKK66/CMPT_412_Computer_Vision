% Q3.3.1
clear all;
close all;

cv_img = imread('../data/cv_cover.jpg');
vid_book = loadVid('../data/book.mov');
vid_panda = loadVid('../data/ar_source.mov');
writeVidAr = VideoWriter('../results/video.avi');


vidLen=size(vid_panda,2);
[cvHigh,cvWidth]=size(cv_img);
cvHigh_Half=int32(cvHigh/2);
cvWidth_Half=int32(cvWidth/2);
cvHW=cvHigh/cvWidth;

panda_pic = vid_panda(1).cdata;
[pdHighO,pdWidth,~]=size(panda_pic);
pdHigh = pdHighO-90;
pdHigh_Half=int32(pdHigh/2);
pdWidth_Half=int32(pdWidth/2);

widMark=int32((pdHigh*cvWidth)/cvHigh);
widMark_Half=int32(widMark/2);

x1 = pdWidth_Half-widMark_Half;
x2 = pdWidth_Half+widMark_Half;

y1 = int32(pdHighO/2-pdHigh_Half);
y2 = int32(pdHighO/2+pdHigh_Half);

%vidLen = 1;
open(writeVidAr);
for idx = 1:vidLen

    book_pic = vid_book(idx).cdata;
    panda_pic = vid_panda(idx).cdata;
    
    
    
    [locs1, locs2] = matchPics(cv_img, book_pic);


    if size(locs1,1) < 4
        writeVideo(writeVidAr,book_pic);
        continue;
    end

    [bestH2to1, ~,~] = computeH_ransac(locs1, locs2);

    %y1=pdHigh_Half-cvHigh_Half;
    %y2=pdHigh_Half+cvHigh;
    
    cropped_pd_pic = panda_pic(y1:y2,(x1:x2),:);
    cropped_pd_pic = imresize(cropped_pd_pic, [cvHigh cvWidth]);
    
    comp_pic = compositeH(bestH2to1, cropped_pd_pic, book_pic);

    writeVideo(writeVidAr,comp_pic);
    idx

end
close(writeVidAr);


