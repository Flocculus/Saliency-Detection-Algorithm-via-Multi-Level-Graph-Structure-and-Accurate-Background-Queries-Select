function [Nm,W] = Msalestimation(img, superpixels, spno, itheta, alpha,img2,img3)

[m,n,~] = size(img);


%W
W=Ncalcweights4mr(img, superpixels, spno, itheta,img2,img3);
%D
for i=1:3*spno
    D(i,i)=sum(W(i,:));
end

Bt=unique([superpixels(1,:)]);
Bb=unique([superpixels(m,:)]);
Bl=unique([superpixels(:,1)']);
Br=unique([superpixels(:,n)']);
removed = boundaryremoval(img, superpixels);

y=zeros(3*spno,4);
no=1;
%if removed~=1
for k=1:length(Bt)
    y(Bt(k),no)=1;
    % y(Bt(k)+spno,no)=1;
    % y(Bt(k)+spno+spno,no)=1;
end
no=no+1;
%end
%if removed~=2
for k=1:length(Bb)
    y(Bb(k),no)=1;
    % y(Bb(k)+spno,no)=1;
    %  y(Bb(k)+spno+spno,no)=1;
    
end
no=no+1;
%end
%if removed~=3
for k=1:length(Bl)
    y(Bl(k),no)=1;
    % y(Bl(k)+spno,no)=1;
    % y(Bl(k)+spno+spno,no)=1;
    
end
no=no+1;
%end
%if removed~=4
for k=1:length(Br)
    y(Br(k),no)=1;
    % y(Br(k)+spno,no)=1;
    % y(Br(k)+spno+spno,no)=1;
    
end
no=no+1;
%end
%FF=ones(3*spno,3*spno)-eye(3*spno);
%BB=(((D-alpha*W)^-1).*FF)*y;
BB=((D-alpha*W)^-1)*y;
A=max(BB);
B=min(BB);
Nm=(BB-B)./(A-B);
S=ones(3*spno,4)-Nm;
SS=S(:,1).*S(:,2).*S(:,3).*S(:,4);
SS=(SS-min(SS))/(max(SS)-min(SS));
level = graythresh(SS);
SSS = im2bw(SS,level);
CC=((D-alpha*W)^-1)*SSS;
A=max(CC);
B=min(CC);
Nm=(CC-B)./(A-B);


