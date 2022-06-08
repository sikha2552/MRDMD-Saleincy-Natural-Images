function o=sal_select(salmap_X1,salmap_X2)
%%%%%%%%SELECTION OF SALIENCY MAP%%%%%
s1 = im2bw(salmap_X1,.8);
esal1=entropy(s1);
s2 = im2bw(salmap_X2, .8);
esal2=entropy(s2);
ENTROPY_SAL=[esal1,esal2]
[M_sal,I_sal]=min(ENTROPY_SAL);
[Max_sal,Imax_sal]=max(ENTROPY_SAL);

if M_sal<.5 
   I_sal=Imax_sal; 
else
numBlackBinary1 = numel(s1) - sum(s1(:));
numBlackBinary2 = numel(s2) - sum(s2(:));
black_pixels=[numBlackBinary1,numBlackBinary2];
[M_black,I_black]=max(black_pixels);
I_sal=I_black;
end
if I_sal==1
   o=1;
else 
  o=2;
    
end
% final=enhanceContrast(final,5);
% figure;imshow(final);
