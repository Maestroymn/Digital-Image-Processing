% Reading input image
I = imread('baboon.png');
% Doubling image
baboon_img = im2double(I);

[X,Y] = meshgrid(-floor(size(smile,1)/2):floor(size(smile,2)/2), -floor(size(smile,1)/2):floor(size(smile,2)/2));
dist = sqrt(X.^2 + Y.^2);
kernel = 1 ./ (1 + dist);
% Kernel h, square matrix
h = kernel / sum(kernel(:));
% Result with my function
my_result=my_imfilter(double(baboon_img),double(h));
% Result by using matlab's imfilter function
official_res=imfilter(double(baboon_img),double(h));
% Comparing the both results
montage({my_result,official_res});title("My Result(Left) vs MATLAB(Right)")

function im_out = my_imfilter(im_in,h)
    [hx, hy] = size(h);             % Reading kernel size
    img_pad = padarray(im_in, [hx hy]);  % Padding original image
    [y, x] = size(img_pad);     % Reading image size
    newImg = zeros(x,y);         % Creating empty matrix to store the result 
    for i=(1+hy):(y-hy)         % traversing through each image row
        for j=(1+hx):(x-hx)     % traversing through each image pixel        
            neighborhood = img_pad(i-floor(hy/2):i+floor(hy/2), j-floor(hx/2):j+floor(hx/2));   % Creating local neighborhood of input image
            accum = 0;          % setting accumulator to 0
            for a=1:hy      % traversing through each kernel row 
                for b=1:hx  % traversing through each kernel element
                    temp_val = neighborhood(a,b)*kr(a,b);
                    accum = accum + temp_val;
                end
            end
            newImg(i,j) = accum;   % Set value of pixel in new image with convolution operation resultant
        end
    end
    im_out=newImg(1+hy:y-hy,1+hx:x-hx); % Removing image padding
end