Image=imread('panda.png');
% Cutoff frequency that is used for the experiment, in my case I used 0.05
% and 0.25
cutoffFreq=0.05;
% Convert to grayscale
figure;imshow(Image);title('Original Version');

% Determine good padding for Fourier transform
PQ = size(Image);

% Create a Lowpass filter 5% the width of the Fourier transform
D0 = cutoffFreq*PQ(1);
H = lpfilter('gaussian', PQ(1), PQ(2), D0);
% H = lpfilter('btw', PQ(1), PQ(2), D0);
% H = lpfilter('ideal', PQ(1), PQ(2), D0);

% Calculate the discrete Fourier transform of the image
F=fft2(double(Image),size(H,1),size(H,2));

% Apply the highpass filter to the Fourier spectrum of the image
LPFS_Image = H.*F;
% convert the result to the spacial domain.
LPF_Image=real(ifft2(LPFS_Image)); 

% Crop the image to undo padding
LPF_Image=LPF_Image(1:size(Image,1), 1:size(Image,2));

% Display the blurred image
figure, imshow(LPF_Image, []);title('Result of the filter applied');
% Display the Fourier Spectrum 
% Move the origin of the transform to the center of the frequency rectangle.
Fc=fftshift(F);
Fcf=fftshift(LPFS_Image);
% use abs to compute the magnitude and use log to brighten display
S1=log(1+abs(Fc)); 
S2=log(1+abs(Fcf));
figure, imshow(S1,[]);title('Fourier spectrum of image before the filter');
figure, imshow(S2,[]);title('Fourier spectrum of image after the filter applied');
