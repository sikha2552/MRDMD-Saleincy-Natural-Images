function sal= compute_sal(mrdmd,n,nx,ny)
%%%Output for different levels
out1=reshape(abs(mrdmd{1,1}.Phi(1:n,1)), nx, ny);
sp1 = (out1 - min(out1(:)))./(max(out1(:)) - min(out1(:)));
sp1=enhanceContrast(sp1,10);
% figure;imshow(sp1);title('saliencymap 1-1');
% figure;
if isempty(mrdmd{2,1}.Phi)
    out2=out1;
else
out2=reshape(abs(mrdmd{2,1}.Phi(1:n,1)), nx, ny);
end
% imshow(out2,[]);title('2-1');
sp2 = (out2 - min(out2(:)))./(max(out2(:)) - min(out2(:)));
sp2=enhanceContrast(sp2,10);
% figure;imshow(sp2);title('saliencymap 2-1');
% figure;

if isempty(mrdmd{3,1}.Phi)
    out3=out2;
else
out3=reshape(abs(mrdmd{3,1}.Phi(1:n,1)), nx, ny);
end
%imshow(out3,[]);title('3-1');
sp3 = (out3 - min(out3(:)))./(max(out3(:)) - min(out3(:)));
sp3=enhanceContrast(sp3,10);
% figure;imshow(sp3);title('saliencymap 3-1');
%%
%%%%%ENTROPY for LEVELS
oute1 = im2bw(out1, mean(out1(:))); e11=entropy(oute1);
oute2 = im2bw(out2, mean(out2(:)));e21=entropy(oute2);
oute3 = im2bw(out3, mean(out3(:)));e31=entropy(oute3);
ENTROPY=[e11,e21,e31]
[Emin Imin]=min(ENTROPY);
[Emax Imax]=max(ENTROPY);
if (Emin<.5) | ((Emax-Emin <0.05)) 
        Imin=Imax;
% elseif ((abs(e21-e31))<.08)
%         Imin=2; 
end
if Imin==1
    sal=sp1;
elseif Imin==2
    sal=sp2;
   %figure;imshow(sal);title('sikha');
else
    sal=sp3;
end
% sal= morphSmooth(sal,12);
sal=enhanceContrast(sal,5);

% figure;imshow(sal,[]);title('final');
end