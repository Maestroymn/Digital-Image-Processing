close all;

I = imread('boy.png');
figure;imshow(I);title('Original Image');
% Producing %30 noised pixelled version of the input image
noised_ver = imnoise(I,'salt & pepper',0.3);
% Median filtering results for %30 noised version
medfilt_res_7 = medfilt2(noised_ver,[7,7]);
medfilt_res_15 = medfilt2(noised_ver,[15,15]);
% Average filtering results for %30 noised version
avg_res_7=fspecial('average',[7,7]);           
avg_filt_res_7=imfilter(noised_ver,avg_res_7);
avg_res_15=fspecial('average',[15,15]);           
avg_filt_res_15=imfilter(noised_ver,avg_res_15);
% Combined output for %30 noised version
figure;montage({avg_filt_res_7,avg_filt_res_15,medfilt_res_7,medfilt_res_15});title('Image Order: 7x7 avg, 15x15 avg, 7x7 medfilt, 15x15 medfilt (X=30)');

% Producing %50 noised pixelled version of the input image
noised_ver1 = imnoise(I,'salt & pepper',0.5);
% Median filtering results for %50 noised version
medfilt_res_7 = medfilt2(noised_ver1,[7,7]);
medfilt_res_15 = medfilt2(noised_ver1,[15,15]);
% Average filtering results for %50 noised version
avg_res_7=fspecial('average',[7,7]);            
avg_filt_res_7=imfilter(noised_ver1,avg_res_7);
avg_res_15=fspecial('average',[15,15]);            
avg_filt_res_15=imfilter(noised_ver1,avg_res_15);
% Combined output for %50 noised version
figure;montage({avg_filt_res_7,avg_filt_res_15,medfilt_res_7,medfilt_res_15});title('Image Order: 7x7 avg, 15x15 avg, 7x7 medfilt, 15x15 medfilt (X=50)');
