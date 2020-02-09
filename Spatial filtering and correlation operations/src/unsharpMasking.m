I = imread('moon.png');
% Sigma value for the imgaussfilt function
sigma = 1.5;
sharpenedImg = m_function(I,sigma);
figure;montage({I,sharpenedImg});title('Original Image (Left) Vs. Sharpened Image (Right)');

function sharpened = m_function(input_img,sigmaVal)
    blurred = imgaussfilt(input_img,sigmaVal,'FilterSize',[7,7]);
    edgeImage = imsubtract(input_img,blurred);
    sharpened = imadd(edgeImage,input_img);
end