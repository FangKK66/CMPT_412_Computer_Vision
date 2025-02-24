function [ composite_img ] = compositeH( H2to1, template, img )
%COMPOSITE Create a composite image after warping the template image on top
%of the image using the homography

% Note that the homography we compute is from the image to the template;
% x_template = H2to1*x_photo
    % For warping the template to the image, we need to invert it.
    %H_template_to_img = inv(H2to1);

    %% Create mask of same size as template
    [len,width,dem]=size(template);
    mask = ones(len,width,dem);
    
    %% Warp mask by appropriate homography
    mask_w = warpH(mask, H2to1, size(img),255);
    mask_w_1=mask_w(:,:,1);
    %imshow(mask_w);
    %saveas(gcf,'../results/4_6_0.jpg');
    %figure()

    %% Warp template by appropriate homography
    img_w = warpH(template, H2to1, size(img));
    %imshow(img_w);

    %% Use mask to combine the warped template and the image
    composite_img = img;
    composite_img(mask_w < 1.5)=img_w(mask_w < 1.5);
end