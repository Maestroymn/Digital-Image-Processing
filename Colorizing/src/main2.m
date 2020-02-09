clear all;

%Read the image
imname = 'monastery';
input = strcat(imname,'.png');

% Output .png file names
beforeAlignment =strcat(imname,'Before.png');
afterAlignmentNCC =strcat(imname,'ResultNCC.png');
afterEnhanceNCC = strcat(imname,'EnhanceResultNCC.png');
afterAlignmentSSD =strcat(imname,'ResultNormSSD.png');
afterEnhanceSSD = strcat(imname,'EnhanceResultSSD.png');

% Constant values used to improve the contrast of images
factor = 1.1;
gamma = 0.75;

% read in the image
fullim = imread(input);

% convert to double matrix
fullim = im2double(fullim);

% compute the height of each part (just 1/3 of total)
height = floor(size(fullim,1)/3);

% separate color channels
B = fullim(1:height,:);
G = fullim(height+1:height*2,:);
R = fullim(height*2+1:height*3,:);

% create a color image (3D array)
rgbNotAligned(:,:,1) = R;
rgbNotAligned(:,:,2) = G;
rgbNotAligned(:,:,3) = B;
cropp = rgbNotAligned(22:325, 24:375, :);
imwrite(cropp,beforeAlignment);

% Croping seperated images for NCC
nR = R(22:325, 24:375, :);
nG = G(22:325, 24:375, :);
nB = B(22:325, 24:375, :);

% NCC way
c = normxcorr2(nR,nB);
[ypeak, xpeak] = find(c==max(c(:)));
yoffSet = ypeak-size(nR,1);
xoffSet = xpeak-size(nR,2);

nccR = circshift(nR, [yoffSet, xoffSet]);

c = normxcorr2(nG,nB);
[ypeak, xpeak] = find(c==max(c(:)));
yoffSet = ypeak-size(nG,1);
xoffSet = xpeak-size(nG,2);

nccG = circshift(nG, [yoffSet, xoffSet]);
NccRes(:,:,1) = nccR;
NccRes(:,:,2) = nccG;
NccRes(:,:,3) = nB;
imwrite(NccRes,afterAlignmentNCC);

enhanceNCC = enhance(NccRes,gamma,factor);
imwrite(enhanceNCC,afterEnhanceNCC);

% SSD way
nR = align(G,R);
nB = align(G,B);
ColorImg_aligned = cat(3,nR,G,nB);
cropImg = ColorImg_aligned(22:325, 24:375, :);
imwrite(cropImg,afterAlignmentSSD);

% Enhancing the image, improving the quality of image
enhanceSSD = enhance(ColorImg_aligned,gamma,factor);

% Cropping the enhanced result
croppedImage = enhanceSSD(22:325, 24:375, :);
imwrite(croppedImage,afterEnhanceSSD);

% Align function for ssd
function aligned = align(green,red)
    [red_row,red_col] = size(red);
    [green_row,green_col] = size(green);

    % checking SSD for cropped part of the images for faster calculation 
    cropped_red = red(ceil((red_row-50)/2) : ceil((red_row-50)/2) + 50,ceil((red_col-50)/2) :ceil((red_col-50)/2) + 50);
    cropped_green = green(ceil((green_row-50)/2) : ceil((green_row-50)/2) + 50,ceil((green_col-50)/2) :ceil((green_col-50)/2) + 50);

    MiN = 99999;
    r_index = 0;
    r_dim = 1;
    % Modifications
    for i = -15:15
        for j = -15:15
            ssd =     SSD(cropped_green,circshift(cropped_red,[i,j])); %circshift(A,[i,j])
            if ssd < MiN
                MiN = ssd;
                r_index = i;
                r_dim = j;
            end
        end
    end
    aligned = circshift(red,[r_index,r_dim]);
end  

% enhance function for improving the quality of image
function enhanceResult = enhance(img,gamma,factor)
    % Gamma Correction
    imd = double(img);
    [m,n] = size(imd);
    out = abs((1*imd).^gamma);
    maxm = max(out(:));
    minm = min(out(:));
    for i=1:m
        for j=1:n
            out(i,j) = (255*out(i,j))/(maxm-minm);
        end
    end
    out = uint8(out);
    % Histogram Equalization
    histResult = histeq(out);
    % HSV Color space enhance part
    hsvImage = rgb2hsv(histResult);
    hChannel = hsvImage(:, :, 1);
    sChannel = hsvImage(:, :, 2);
    vChannel = hsvImage(:, :, 3);
    meanV = mean2(vChannel);
    newV = meanV + factor * (vChannel - meanV); 
    newHSVImage = cat(3, hChannel, sChannel, newV);
    enhanceResult = hsv2rgb(newHSVImage);
end

% SSD way function
function ssd = SSD(a1,a2)
    x = double(a1)-double(a2);
    ssd = sum(x(:).^2);
end