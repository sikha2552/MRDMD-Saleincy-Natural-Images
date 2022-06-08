close all;
clear all;
clc;
img = imread('D:\1_DMD\0_Implementation details\0_Datasets\ACHANTA\0_FINAL\im15.jpg');
img=imresize(img,[250,250]);
BW = im2bw(img, graythresh(img));
numBlackBinary1 = numel(BW) - sum(BW(:))
numwhite=sum(BW(:))
if numwhite>numBlackBinary1
    1
    BW=(1-BW);
end
figure;imshow(BW);

% img=imnoise(img,'gaussian',.3);
% % % % path ='D:\1_DMD\0_Implementation details\0_Datasets\THU\DATA';
% % % %  path1 = strcat(path,'\dog\');
% % % % RR='D:\3_MR_DMD\SALIENCY_OUT\THU\'
% % % % RR1='D:\3_MR_DMD\SALIENCY_OUT\THU\1\'
% % % % 
% % % % images=dir(strcat(path1,'*.jpg'))

% img=imread('Y:\RESULTS\0_ACHANTA\0_FINAL\im1.jpg');
% % % for ks=1:numel(images)
% % %      file_name=images(ks).name;
% % %     I=strcat(path1,file_name);
% % %     img=imread(I);
% % %       img=imresize(img,[250,250]);
% % %        imagegt=dir(strcat(path1,'*.png'))
% % %          file_name=imagegt(ks).name;
% % %     Ig=strcat(path1,file_name);
% % %     gt=imread(Ig);
% % %     gt=imresize(gt,[250,250]);

%%%%%%%%%%%%%%%%%%%Color Channel Seperation%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
R=img(:,:,1);
G=img(:,:,2);
B=img(:,:,3);
U = -0.14713 * R - 0.28886 * G + 0.436 * B; % U component
V = 0.615 * R - 0.51499 * G - 0.10001 * B; % V component
YCBCR = rgb2ycbcr(img);
cb=YCBCR(:,:,2);
cr=YCBCR(:,:,3);
cform = makecform('srgb2lab', 'AdaptedWhitePoint', whitepoint('d65'));
lab = applycform(img,cform);
a= double(lab(:,:,2));
IR = imgaussfilt(R,3);
V=imgaussfilt(V,2);
G=imgaussfilt(G,2);
% figure;imshow(IR);title('blurr');
b= double(lab(:,:,3));
d1=b+double(V)+double(cr);

%%%%%%%%%%%%%%%%%%%%%%%%% Data Matrix Preparation%%%%%%%%%%%%%%%%%%%%%%%%%%
BW = edge(R,'Canny');
BW=double(BW);
x1=[b(:),BW(:),double(V(:)),double(cr(:)),BW(:),double(G(:)),b(:).*b(:),BW(:),double(V(:)),BW(:),double(cr(:)),b(:),double(G(:)),b(:).*b(:),BW(:),b(:).*b(:)];
x2=[a(:),BW(:),double(IR(:)),double(U(:)),double(cb(:)),BW(:),double(d1(:)),a(:).*a(:),BW(:),double(U(:)),BW(:),double(cb(:)),a(:),double(d1(:)),a(:).*a(:),BW(:),a(:).*a(:)];
%% compute mrDMD
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
%%
salx1=compute_sal(mrdmd,n,nx,ny);
salx2=compute_sal(mrdmd1,n,nx,ny);
%       final2=morphSmooth(out,6);
%      final2 = enhanceContrast(final2, 12);

salx1 = (salx1 - min(salx1(:)))./(max(salx1(:)) - min(salx1(:)));
salx2 = (salx2 - min(salx2(:)))./(max(salx2(:)) - min(salx2(:)));
salx1=imfilter( salx1, fspecial('gaussian', [3,3], .25));
salx2=imfilter( salx2, fspecial('gaussian', [3,3], .25));


salx1=morphSmooth(salx1,6);salx1=enhanceContrast(salx1,6);
salx2=morphSmooth(salx2,6);salx2=enhanceContrast(salx2,6);
% % % imwrite(salx1,[RR,strcat('seg', num2str(ks+88)),'.jpg']);
% % % imwrite(salx2,[RR1,strcat('seg', num2str(ks+88)),'.jpg']);
% % % imwrite(gt,[RR,strcat('seg', num2str(ks+88)),'.png']);
% % % end
figure;imshow(salx1,[]);title('SALIENCY MAP X1');
figure;imshow(salx2,[]);title('SALIENCY MAP X2')
% o=sal_select(salx1,salx2);
% if o==1
%     
%     figure;imshow(salx1,[]);title('final');
% else
%   figure;imshow(salx2,[]);title('final');
% end  
% imwrite(salx1,'1.jpg');

%%
% T=10;
% figure; 
% imagesc(-map); 
% set(gca, 'YTick', 0.5:(L+0.5), 'YTickLabel', floor(low_f*10)/10); 
% set(gca, 'XTick', J/T*(0:T) + 0.5);
% set(gca, 'XTickLabel', (get(gca, 'XTick')-0.5)/J*T);
% axis xy;
% xlabel('Time (sec)');
% ylabel('Freq. (Hz)');
% colormap spring;
% grid on;