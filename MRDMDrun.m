close all;
clear all;
clc;
% img = imread('D:\PENDING\steg\out.png');
% img=imread('272.jpg');
% img=imresize(img,[250,250]);
path ='D:\1_DMD\0_Implementation details\0_Datasets';
path1 = strcat(path,'\MSRA-20000\');
%  RR='D:\3_MR_DMD\SALIENCY_OUT\REVISE2_imagerep\'
% % % % % % % % % RR1='D:\3_MR_DMD\SALIENCY_OUT\THU\1\'
% % % % % % % % 
 images=dir(strcat(path1,'*.jpg'))
% % % % % % % % % % % % % 
% img=imread('D:\4_RGBD\Demo\RGB\1.bmp');
% gt=imread('D:\4_RGBD\Demo\groundtruth\8_08-45-57.jpg');
for ks=1:1%500
     file_name=images(ks).name;
    I=strcat(path1,file_name);
    img=imread(I);
      img=imresize(img,[250,250]);
  img=imnoise(img,'gaussian',.3);
       imagegt=dir(strcat(path1,'*.png'))
         file_name=imagegt(ks).name;
    Ig=strcat(path1,file_name);
   gt=imread(Ig);
   gt=imresize(gt,[250,250]);
 
[counts,x] = imhist(rgb2gray(img),16);
T = otsuthresh(counts);
BW=im2bw(rgb2gray(img), graythresh(img));
numBlackBinary1 = numel(BW) - sum(BW(:))
numwhite=sum(BW(:))
if numwhite>numBlackBinary1
  BW=(1-BW);
end
%  BW=imclearborder(BW,4);
% figure;imshow(BW);title('reference binary');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Color Channel Seperation%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
R=img(:,:,1); G=img(:,:,2); B=img(:,:,3);
U = -0.14713 * R - 0.28886 * G + 0.436 * B; % U component
V = 0.615 * R - 0.51499 * G - 0.10001 * B; % V component
YCBCR = rgb2ycbcr(img); cb=YCBCR(:,:,2); cr=YCBCR(:,:,3);
cform = makecform('srgb2lab', 'AdaptedWhitePoint', whitepoint('d65'));
lab = applycform(img,cform); a= double(lab(:,:,2));b= double(lab(:,:,3));
IR = imgaussfilt(R,3); V=imgaussfilt(V,2); G=imgaussfilt(G,2); d1=b+double(V)+double(cr);

%%%%%%%%%%%%%%%%%%%%%%%%% Data Matrix Preparation%%%%%%%%%%%%%%%%%%%%%%%%%%
BW = edge(R,'Canny');
BW=double(BW);
% x1=[b(:),BW(:),double(V(:)),double(cr(:)),BW(:),double(G(:)),b(:).*b(:),BW(:),double(V(:)),BW(:),double(cr(:)),b(:),double(G(:)),b(:).*b(:),BW(:),b(:).*b(:)];
% x2=[a(:),BW(:),double(IR(:)),double(U(:)),double(cb(:)),BW(:),double(d1(:)),a(:).*a(:),BW(:),double(U(:)),BW(:),double(cb(:)),a(:),double(d1(:)),a(:).*a(:),BW(:),a(:).*a(:)];


x1=[b(:),BW(:),double(cr(:)),BW(:),b(:).*b(:),BW(:),BW(:),double(cr(:)),b(:),b(:).*b(:),BW(:),b(:).*b(:),double(d1(:))];
x2=[a(:),BW(:),double(U(:)),double(cb(:)),BW(:),double(d1(:)),a(:).*a(:),BW(:),double(U(:)),BW(:),double(cb(:)),a(:),double(d1(:)),a(:).*a(:),BW(:),a(:).*a(:)];

%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% compute mrDMD %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 gt=imresize(gt,[250,250]);
% gt=rgb2gray(gt);
nx=250;
ny=250;
n=nx*ny
L = 3; % number of levels
r = 30; % rank of truncation
dt=1;
X=[x1,x2];
mrdmd = mrDMD(x1, dt, r, 2, L);
mrdmd1 = mrDMD(x2, dt, r, 2, L);
% compile visualization of multi-res mode amplitudes
[map, low_f] = mrDMD_map(mrdmd);
[map1, low_f1]= mrDMD_map(mrdmd1);
[L, J] = size(mrdmd);
salx1=compute_sal_ssim(mrdmd,n,nx,ny,double(gt));
salx2=compute_sal_ssim(mrdmd1,n,nx,ny,double(gt));
% salx1=compute_sal(mrdmd,n,nx,ny);
% salx2=compute_sal(mrdmd1,n,nx,ny);
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
figure;imshow(salx1);title('sm1');
figure;imshow(salx2);title('sm2');
x1bw=im2bw(salx1,graythresh(salx1));x2bw=im2bw(salx2,graythresh(salx2));


sim1=ssim(double(x1bw),double(gt));sim2=ssim(double(x2bw),double(gt));
SSIM=[sim1,sim2];
[M I]=max(SSIM);
if I==1
    SMAP=salx1;
else
    SMAP=salx2;
end
% ks=ks+64;
SMAP=(SMAP - min(SMAP(:)))./(max(SMAP(:)) - min(SMAP(:)));
SMAP=morphSmooth(SMAP,6);salx1=enhanceContrast(SMAP,12);
figure;imshow(SMAP,[]);
%time(ks)=toc;
imwrite(SMAP,'.3.jpg');
imwrite(SMAP,[RR,strcat('seg', num2str(ks+150)),'.jpg']);
 imwrite(gt,[RR,strcat('seg', num2str(ks+150)),'.png']);
%imwrite(gt,[RR,strcat('seg', num2str(ks+88)),'.png']);
%  figure;imshow(SMAP,[]);title('final');
end