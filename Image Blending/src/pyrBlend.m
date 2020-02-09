close all
clear
% Input images 
imga = im2double(imread('istanbul.jpg'));
imgb = im2double(imread('prag.jpg')); % size(imga) = size(imgb)
% imga = im2double(imread('orange.png'));
% imgb = im2double(imread('apple.png')); 
% imga = im2double(imread('world.jpeg'));
% imgb = im2double(imread('moon.jpg')); 

figure;imshow(imga);title('Input Image 1');
figure;imshow(imgb);title('Input Image 2');
[M,N,~] = size(imga);

level = 5; 
limga = genPyr(imga,'lap',level); % the Laplacian pyramid
limgb = genPyr(imgb,'lap',level);

% Binary mask input 
maska = im2double(imread('cityMask.png'));
% maska = im2double(imread('fruitMask.png'));
% maska = im2double(imread('planetMask.png'));
maskb = 1-maska;
blurh = fspecial('gauss',150,75); % feather the border
maska = imfilter(maska,blurh,'replicate');
maskb = imfilter(maskb,blurh,'replicate');
figure;imshow(maska);title('maska');
figure;imshow(maskb);title('maskb');

limgo = cell(1,level); % the blended pyramid
for p = 1:level
	[Mp, Np, ~] = size(limga{p});
	maskap = imresize(maska,[Mp Np]);
	maskbp = imresize(maskb,[Mp Np]);
    limgo{p} = limga{p}.*maskap + limgb{p}.*maskbp;
    figure;imshow(limgo{p});
end

imgo = pyrReconstruct(limgo);
figure,imshow(imgo);title('Blend by Pyramid Result'); % blend by pyramid
% imgo1 = maska.*imga+maskb.*imgb;
% figure,imshow(imgo1);title('Blend by Feathering Result'); % blend by feathering
