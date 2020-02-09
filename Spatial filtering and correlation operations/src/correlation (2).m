close all;
smile = imread("smile.png");
emoji = imread("emoji.png");

[X,Y] = meshgrid(-floor(size(smile,1)/2):floor(size(smile,2)/2), -floor(size(smile,1)/2):floor(size(smile,2)/2));
dis = sqrt(X.^2 + Y.^2);
kern = 1 ./ (1 + dis);
h = kern / sum(kern(:));

finalImg1=my_imfilter(double(emoji),double(smile));
figure;imshow(finalImg1,[]);
% Detecting the max peak, which also means the center of the template
% matching we used
[ypeak, xpeak] = find(finalImg1==max(finalImg1(:)));
% For rectangle drawing purposes:
xpeak = xpeak-size(smile,2)/2;
ypeak = ypeak-size(smile,1)/2;
% I draw a rectangle around the matching emoji
figure;imshow(emoji,[]);drawrectangle('Position', [ xpeak+1,ypeak+1, size(smile,2), size(smile,1)]);

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
                    temp_val = neighborhood(a,b)*h(a,b);
                    accum = accum + temp_val;
                end
            end
            newImg(i,j) = accum;   % Set value of pixel in new image with convolution operation resultant
        end
    end
    im_out=newImg(1+hy:y-hy,1+hx:x-hx); % Removing image padding
end