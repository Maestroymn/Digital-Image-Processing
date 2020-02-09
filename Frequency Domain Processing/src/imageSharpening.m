Image=imread('panda.png');
figure;imshow(Image);title('Original version');

% Cutoff frequency that is used for the experiment, in my case I used 0.05
% and 0.25
cutoffFreq=0.05;

%Determine good padding for Fourier transform
PQ = size(Image);

%Create a Gaussian Highpass filter 5% the width of the Fourier transform
D0 = cutoffFreq*PQ(1);
H = hpfilter('gaussian', PQ(1), PQ(2), D0);
% H = hpfilter('btw', PQ(1), PQ(2), D0);
% H = hpfilter('ideal', PQ(1), PQ(2), D0);

% Calculate the discrete Fourier transform of the image
F=fft2(double(Image),size(H,1),size(H,2));

% Apply the highpass filter to the Fourier spectrum of the image
HPFS_Image = H.*F;

% convert the result to the spacial domain.
HPF_Image=real(ifft2(HPFS_Image)); 

% Crop the image to undo padding
HPF_Image=HPF_Image(1:size(Image,1), 1:size(Image,2));

%Display the "Sharpened" image
figure, imshow(HPF_Image, []);title('Result of the filter applied');

% Display the Fourier Spectrum
% Move the origin of the transform to the center of the frequency rectangle.
Fc=fftshift(F);
Fcf=fftshift(HPFS_Image);
% use abs to compute the magnitude and use log to brighten display
S1=log(1+abs(Fc)); 
S2=log(1+abs(Fcf));
figure, imshow(S1,[]);title('Fourier spectrum of image before the filter');
figure, imshow(S2,[]);title('Fourier spectrum of image after the filter applied');