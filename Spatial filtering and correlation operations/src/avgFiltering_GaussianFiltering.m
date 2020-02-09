I = imread("boy.png");
% Doubling the matrix of input image
I = im2double(I);
% Gaussian filtering operations 
gaussian_res_7x7 = fspecial('gaussian',[7 7], 1.5);
gaus_res_7 = imfilter(I, gaussian_res_7x7);
gaussian_res_15x15 = fspecial('gaussian',[15 15], 3.5);
gaus_res_15 = imfilter(I, gaussian_res_15x15);
% Average filtering operations
avg_res_7x7 = fspecial('average',[7 7]);
avg_res_7 = imfilter(I, avg_res_7x7);
avg_res_15x15 = fspecial('average',[15 15]);
avg_res_15 = imfilter(I, avg_res_15x15);
% Results
figure;montage({gaus_res_7,avg_res_7});title('Gaussian filter 7x7 result(Left) and Average filter 7x7 result(Right)');
figure;montage({gaus_res_15,avg_res_15});title('Gaussian filter 15x15 result(Left) and Average filter 15x15 result(Right)');