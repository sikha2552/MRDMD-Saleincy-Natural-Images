function sm1=compute_sal_ssim(mrdmd,n,nx,ny,BW)
out1=reshape(abs(mrdmd{1,1}.Phi(1:n,1)), nx, ny);
sp1 = (out1 - min(out1(:)))./(max(out1(:)) - min(out1(:)));
sp1=enhanceContrast(sp1,10);
% figure;imshow(sp1,[]);title('sp1');
if isempty(mrdmd{2,1}.Phi)
    out2=out1;
else
out2=reshape(abs(mrdmd{2,1}.Phi(1:n,1)), nx, ny);
end
sp2 = (out2 - min(out2(:)))./(max(out2(:)) - min(out2(:)));
sp2=enhanceContrast(sp2,10);
% figure;imshow(sp2,[]);title('sp2');
if isempty(mrdmd{3,1}.Phi)
    out3=out2;
else
out3=reshape(abs(mrdmd{3,1}.Phi(1:n,1)), nx, ny);
end
% figure;imshow(out3,[]);title('3-1');
sp3 = (out3 - min(out3(:)))./(max(out3(:)) - min(out3(:)));
sp3=enhanceContrast(sp3,10);
oute1 = im2bw(out1, mean(out1(:))); e11=entropy(oute1);
oute2 = im2bw(out2, mean(out2(:)));e21=entropy(oute2);
oute3 = im2bw(out3, mean(out3(:)));e31=entropy(oute3);
ENTROPY=[e11,e21,e31]
[Emin Imin]=min(ENTROPY);

size(sp1)
% figure;imshow(sp3,[]);title('sp3');
sim1=ssim(sp1,BW);sim2=ssim(sp2,BW);sim3=ssim(sp3,BW);
SSIM=[sim1,sim2,sim3]
[M I]=max(SSIM);
if Emin<.5
    I=2
end
if I==1
    sm1=sp1;
elseif I==2
    sm1=sp2;
else
    sm1=sp3;
end

% figure;imshow(sm1);title('sm1');