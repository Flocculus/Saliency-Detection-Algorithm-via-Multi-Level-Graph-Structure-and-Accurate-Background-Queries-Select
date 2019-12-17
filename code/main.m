
clear all
clc

%% Initialization
addpath(genpath('./support/'));
IMG_DIR = './TestData/data/';% Original image path
SAL_DIR='./TestData/solution/' ;% Output path of the saliency map
if ~exist(SAL_DIR, 'dir')
    mkdir(SAL_DIR);
end
imglist=dir([IMG_DIR '*' 'jpg']);

%% Algorithm start
for imgno=1:length(imglist)
    
    % Load input image
    disp(imgno);
    disp(imglist(imgno).name);
    % Calculate saliency
    imgnamein=imglist(imgno).name;
    spn = 200;
    spnb = 24;
    itheta = 10;
    alpha = 0.99;
    % Step 1 & 2: Saliency Estimation
    imgname = [IMG_DIR, imgnamein(1:end-4) '.jpg'];
    imgbmpname = strcat(imgname(1:(end-4)), '.bmp');
    [img, wid] = removeframe(imgname);
    img = uint8(img*255);
    w=fspecial('gaussian',[5,5],15);
    img2=imfilter(img,w);%%%%%%%%%%%1st gaussian
    w=fspecial('gaussian',[55,55],15);
    img3=imfilter(img,w);%%%%%%%%%%%2st gaussian

    [m, n, ~] = size(img);
    comm = ['SLIC_SUPPORT' ' ' imgbmpname ' ' int2str(2) ' ' int2str(spn) ' '];
    evalc('system(comm)');
    spname = [imgbmpname(1:end-4)  '.dat'];
    superpixels = ReadDAT([m,n], spname);
    spno = max(superpixels(:));
    [salest,W] = Msalestimation(img, superpixels, spno, itheta, alpha,img2,img3);
    salest= (salest-min(salest))/(max(salest)-min(salest));
    
    map=superpixels;
    for i=1:spno
        map(map==i)=salest(i);
    end
    map1=reshape(map',n*m,1);

    % Step 3: regularized random walk ranking
    salest=salest(1:spno,1);
    th1 = (mean(salest) + max(salest)) / 2;
    th2 = mean(salest);
    mu = (1-alpha) / alpha;
    [seeds, label] = seed4rw(salest, th1, th2);
    [P] = myrrwr(m,n,img,itheta,superpixels,seeds,label,salest,spno,mu);
    sal = P(:,1);

    salmean = (sal+map1)/2;

    sal = (salmean-min(salmean(:)))/(max(salmean(:))-min(salmean(:)));
    sal=reshape(sal,n,m)';
    saloutput = zeros(wid(1),wid(2));
	saloutput(wid(3):wid(4),wid(5):wid(6)) = sal;
	saloutput = uint8(saloutput*255);
    saliency=saloutput;
    %     Output saliency map to file
    imwrite(saliency, [SAL_DIR, imglist(imgno).name(1:end-4), '_Saliency.png']);

    salest=salest(1:spno,1);
    th1 = (mean(salest) + max(salest)) / 2;
	th2 = mean(salest);
	mu = (1-alpha) / alpha;
	[seeds, label] = seed4rw(salest, th1, th2);
	[~, probabilities] = rrwr(img, superpixels, salest, seeds, label, mu);
	sal = probabilities(:,:,1);
	sal = (sal-min(sal(:)))/(max(sal(:))-min(sal(:)));
    saloutput = zeros(wid(1),wid(2));
	saloutput(wid(3):wid(4),wid(5):wid(6)) = sal;
	saloutput = uint8(saloutput*255);

    saliency=saloutput;
    %     Output saliency map to file
    imwrite(saliency, [SAL_DIR, imglist(imgno).name(1:end-4), '_SaliencyOld.png']);
   % imwrite(map, [SAL_DIR, imglist(imgno).name(1:end-4), '_sal�༶BB.png']);
    clearvars -except IMG_DIR SAL_DIR imglist imgno
end

