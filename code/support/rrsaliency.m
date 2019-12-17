function saloutput = rrsaliency(IMG_DIR, imgnamein)
% Function saloutput = rrsaliency(IMG_DIR, imgnamein) executes the
% proposed regularized random walk ranking algorithm and output the saliency map
% result. See demo_rrwr.m for an example of usage.
%
% Inputs:       IMG_DIR - path of image input image
%                   imgnamein - name of the input image (without path and
%                   suffix); only *.jpg files are supported
% Outputs:    saloutput - the pixel-wise saliency map with the same size as
%                   the input image
%
% 11/05/14 - by Yuchen Yuan
% Based on the paper:
% Changyang Li, Yuchen Yuan, Weidong Cai, Yong Xia, and David Dagan Feng.
% "Robust Saliency Detection via Regularized Random Walks Ranking". CVPR 2015

% Parameter initialization
spn = 200;
itheta = 10;
alpha = 0.99;
disp('rrsaliency')
% Step 1 & 2: Saliency Estimation
imgname = [IMG_DIR, imgnamein(1:end-4) '.jpg'];
imgbmpname = strcat(imgname(1:(end-4)), '.bmp');
[img, wid] = removeframe(imgname);
img = uint8(img*255);
[m, n, ~] = size(img);
comm = ['SLIC_SUPPORT' ' ' imgbmpname ' ' int2str(2) ' ' int2str(spn) ' '];
evalc('system(comm)');
spname = [imgbmpname(1:end-4)  '.dat'];
superpixels = ReadDAT([m,n], spname);
spno = max(superpixels(:));
% delete(imgbmpname);
% delete(spname);
% delete([spname(1:end-4) '_SLIC.bmp']);
mysalest= Msalestimation(img, superpixels, spno, itheta, alpha);
mysalest= (mysalest-min(mysalest))/(max(mysalest)-min(mysalest));
map=superpixels;
for i=1:spno
    map(map==i)=mysalest(i);
end
map = uint8(map*255);





% Step 3: regularized random walk ranking
th1 = (mean(mysalest) + max(mysalest)) / 2;
th2 = mean(mysalest);
%mu=0;
mu = (1-alpha) / alpha;
[seeds, label] = seed4rw(mysalest, th1, th2);
[P] = myrrwr(m,n,img,itheta,superpixels,seeds,label,mysalest,spno,mu);
sal = P(:,1);
sal = (sal-min(sal(:)))/(max(sal(:))-min(sal(:)));
saloutput=reshape(sal,n,m);
saloutput = uint8(saloutput*255)';
%imwrite(map, [SAL_DIR, imglist(imgno).name(1:end-4), '_sal.png']);
end