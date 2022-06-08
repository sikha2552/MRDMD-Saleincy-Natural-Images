img=imread('D:\1_DMD\0_Implementation details\0_Datasets\ACHANTA\0_FINAL\im31.jpg');
img=imresize(img,[300,300]);
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
b= uint8(255 * mat2gray(b));
a= uint8(255 * mat2gray(a));
%  imwrite(b,['D:\3_MR_DMD\WRITEUP\',strcat('b',num2str(ks)),'.jpg']); 
%  imwrite(V,['D:\3_MR_DMD\WRITEUP\',strcat('v',num2str(ks)),'.jpg']); 
%  imwrite(cr,['D:\3_MR_DMD\WRITEUP\',strcat('cr',num2str(ks)),'.jpg']); 
%  imwrite(BW,['D:\3_MR_DMD\WRITEUP\',strcat('BW',num2str(ks)),'.jpg']); 
%  imwrite(U,['D:\3_MR_DMD\WRITEUP\',strcat('U',num2str(ks)),'.jpg']); 
% imwrite(a,['D:\3_MR_DMD\WRITEUP\',strcat('a',num2str(ks)),'.jpg']); 
% imwrite(cb,['D:\3_MR_DMD\WRITEUP\',strcat('cb',num2str(ks)),'.jpg']); 
% imwrite(IR,['D:\3_MR_DMD\WRITEUP\',strcat('gaussr',num2str(ks)),'.jpg']); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% compute mrDMD %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nx=250;
ny=250;
n=nx*ny
L = 3; % number of levels
r = 30; % rank of truncation
dt=1;
X=[x1,x2];
mrdmd = mrDMD(x1, dt, r, 2, L);
out1=reshape(abs(mrdmd{1,1}.Phi(1:n,1)), nx, ny);figure;imshow(out1,[]);title('1-1');
out21=reshape(abs(mrdmd{2,1}.Phi(1:n,1)), nx, ny);figure;imshow(out21,[]);title('2-1');
out22=reshape(abs(mrdmd{2,2}.Phi(1:n,1)), nx, ny);figure;imshow(out22,[]);title('2-2');
out3=reshape(abs(mrdmd{3,4}.Phi(1:n,1)), nx, ny);figure;imshow(out3,[]);title('3-4');
T=10;
figure; 
imagesc(-map); 
set(gca, 'YTick', 0.5:(L+0.5), 'YTickLabel', floor(low_f*10)/10); 
set(gca, 'XTick', J/T*(0:T) + 0.5);
set(gca, 'XTickLabel', (get(gca, 'XTick')-0.5)/J*T);
axis xy;
xlabel('Time (sec)');
ylabel('Freq. (Hz)');
colormap spring;
grid on;
