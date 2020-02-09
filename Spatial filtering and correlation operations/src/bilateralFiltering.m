close all;
I = imread('baboon.png');
degreeOfSmoothing = 1;
spatialSigma = 1;
J = imbilatfilt(I,degreeOfSmoothing*10,spatialSigma);
A = imbilatfilt(I,degreeOfSmoothing*100,spatialSigma*10);
B = imbilatfilt(I,degreeOfSmoothing*300,spatialSigma*30);
K = imbilatfilt(I,degreeOfSmoothing*100,spatialSigma*100);
figure;montage({I,J,A,B});
figure;imshow(K);title('100 smoothing and 100 spatialSigma');