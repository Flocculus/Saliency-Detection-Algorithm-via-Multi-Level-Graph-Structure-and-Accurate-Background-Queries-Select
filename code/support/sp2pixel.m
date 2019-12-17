function [S,L]=sp2pixel(superpixels,m,n,seeds,label)
xx=zeros(m,n);
xx(5:5:end,5:5:end)=superpixels(5:5:end,5:5:end);
superpixels=xx;
xxxx=reshape(superpixels',m*n,1);

S=[];
L=[];
for i=1:m*n
    for j=1:length(seeds)
        if xxxx(i)==seeds(j)
            S=[S i];
            L=[L label(j)];
        end
    end
end
            
            
   