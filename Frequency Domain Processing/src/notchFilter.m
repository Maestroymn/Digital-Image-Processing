f = imread('ball.png');
% f = imread('bone.png');
% f = imread('skull.png');
figure;imshow(f);title('Original version');
F = fftshift(fft2(double(f)));
S = log(abs(F));
imwrite( S/max(S(:)), 'mask.tif');
figure;imshow('mask.tif');title('Fourier Spectrum of the original image');
% % Edit image 'mask.tif' with another application such as "Paint".
% % Draw black squares or circles at noise locations. Save it back
% % to 'mask.tif‘.
pause;
M = imread('mask.tif');
M = M(:,:,1); % Use only first band of color image
M = double((M>0)); % Threshold, so 0's are at noise locations
G = M .* F;
g = real( ifft2( ifftshift(G) ) );
figure;imshow(g, []);title('Result after the notch filters applied');



 