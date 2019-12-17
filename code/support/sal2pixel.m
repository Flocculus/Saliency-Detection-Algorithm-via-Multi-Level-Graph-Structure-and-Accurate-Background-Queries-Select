function [O]=sal2pixel(superpixels,m,n,sal,spno)
disp('sal2pixels');
O=superpixels;

for i=1:spno
    O(O==i)=sal(i);
end

O=reshape(O',m*n,1);