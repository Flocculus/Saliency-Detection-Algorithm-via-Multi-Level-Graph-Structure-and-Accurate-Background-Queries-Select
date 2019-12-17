function weights=Mmakeweights(edges,img,theta)
[m,n,k] = size(img);

% Calculate average Lab value of each pixel
Img(:,:,1)=img(:,:,1)';
Img(:,:,2)=img(:,:,2)';
Img(:,:,3)=img(:,:,3)';
input_pixels=reshape(Img, m*n, k);
img_lab = colorspace('Lab<-', input_pixels);

weights=exp(-(1)*sqrt(sum((img_lab(edges(:,1),:)-img_lab(edges(:,2),:)).^2,2)));



