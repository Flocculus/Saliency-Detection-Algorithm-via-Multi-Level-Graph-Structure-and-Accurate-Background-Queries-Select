function [P]=myrrwr(m,n,img,theta,superpixels,seeds,label,mysalest,spno,mu)

N=m*n;

%Build graph
[edges]=mylattice(n,m);

weights=Mmakeweights(edges,img,theta);

%Build sparse adjacency matrix
W=sparse([edges(:,1);edges(:,2)],[edges(:,2);edges(:,1)],[weights;weights],N,N);
L=diag(sum(W))-W;

[s,l]=sp2pixel(superpixels,m,n,seeds,label);

%Set up Dirichlet problem
boundary=zeros(length(s),2);
for k=1:2
    boundary(:,k)=(l(:)==k);
end



%Solve for random walker probabilities by solving combinatorial Dirichlet
%problem

P=dirichletboundary(L,s(:),boundary,superpixels,m,n,mysalest,spno,mu);

end
            
            
   