function [edge] = mylattice(X,Y)
%X����Y����

N=X*Y;

edges=[[1:N]',[(1:N)+1]'];%��1
edges=[[edges(:,1);[1:N]'],[edges(:,2);[1:N]'+X]];%��1

border=1:N;
border1=find(mod(border,X)-1)';
border2=find(mod(border,X))';
edges=[edges;[border1,border1+X-1;border2,border2+X+1]];%����1����1
excluded=find((edges(:,1)>N)|(edges(:,1)<1)|(edges(:,2)>N)|(edges(:,2)<1));%��Ȧ����
edges([excluded;[X:X:((Y-1)*X)]'],:)=[];%��Ȧ����


edgesO=[[1:N]',[(1:N)+2]'];%��2
edgesO=[[edgesO(:,1);[1:N]'],[edgesO(:,2);[1:N]'+2*X]];%��2��1

edgesO=[[edgesO(:,1);[1:N]'],[edgesO(:,2);[1:N]'+2+X]];%��2��2


edgesO=[[edgesO(:,1);[1:N]'],[edgesO(:,2);[1:N]'+2*X]];%��2
edgesO=[[edgesO(:,1);[1:N]'],[edgesO(:,2);[1:N]'+2+X]];%��2��1



border=1:N;
border1=find(mod(border,X)>2 | mod(border,X)<1)';%��2
border2=find(mod(border,X)>1 | mod(border,X)<1)';%��1
edgesO=[edgesO;border1,border1+X-2;border2,border2+X-1+X;border1,border1+X-2+X];%��2��1��1��2��2��2



excluded=find((edgesO(:,1)>N)|(edgesO(:,1)<1)|(edgesO(:,2)>N)|(edgesO(:,2)<1));%��Ȧ����
edgesO([excluded;[X:X:((Y-1)*X)]';[(X-1):X:(((Y-1)*X)-1)]';[(N+X):X:(N+((Y-1)*X))]';[(2*N+X):X:(2*N+(Y-1)*X)]';[(2*N+X-1):X:(2*N+((Y-1)*X)-1)]';[(4*N+X):X:(4*N+(Y-1)*X)]';[(4*N+X-1):X:(4*N+((Y-1)*X)-1)]';],:)=[];%��Ȧ����

%��Ȧ����
tmp=1:N;
tmp=reshape(tmp,X,Y);
tmp=tmp';
inner=tmp(2:Y-1,2:X-1);
inner=reshape(inner',(X-2)*(Y-2),1);
l=length(inner);
outer=[tmp(1,:),tmp(Y,:),tmp(2:Y-1,1)',tmp(2:Y-1,X)']';
L=length(outer);
[Outer Inner]=meshgrid(outer,inner);
Inner=Inner';
Outer=Outer';
edgein=[Inner(:),Outer(:)];


%�ظ�
ex=[1 2 3 4 2*X+1 2*X+2 2*X+3];
ex=[ex L+1 L+2 L+3 L+4 L+5 L+2*X+1 L+2*X+2 L+2*X+3];
ex=[ex (X-2)*L+1 (X-2)*L+2 (X-2)*L+3 (X-2)*L+4 (X-2)*L+2*X+1 (X-2)*L+2*X+2 (X-2)*L+2*X+3 (X-2)*L+2*X+4]; %����3����

ex=[ex (X-4)*L+X-4 (X-4)*L+X-3 (X-4)*L+X-2 (X-4)*L+X-1 (X-4)*L+X (X-4)*L+2*X+Y-1 (X-4)*L+2*X+Y (X-4)*L+2*X+Y+1];
ex=[ex (X-3)*L+X-3 (X-3)*L+X-2 (X-3)*L+X-1 (X-3)*L+X (X-3)*L+2*X+Y-1 (X-3)*L+2*X+Y (X-3)*L+2*X+Y+1];
ex=[ex (2*X-5)*L+X-3 (2*X-5)*L+X-2 (2*X-5)*L+X-1 (2*X-5)*L+2*X+Y-1 (2*X-5)*L+2*X+Y (2*X-5)*L+2*X+Y+1 (2*X-5)*L+2*X+Y+2]; %����

ex=[ex (Y-4)*(X-2)*L+2*X+Y-5 (Y-4)*(X-2)*L+2*X+Y-4  (Y-4)*(X-2)*L+2*X+Y-3  (Y-4)*(X-2)*L+2*X+Y-2 (Y-4)*(X-2)*L+X+1 (Y-4)*(X-2)*L+X+2 (Y-4)*(X-2)*L+X+3 (Y-4)*(X-2)*L+X+4];
ex=[ex (Y-3)*(X-2)*L+2*X+Y-4 (Y-3)*(X-2)*L+2*X+Y-3 (Y-3)*(X-2)*L+2*X+Y-2 (Y-3)*(X-2)*L+X+1 (Y-3)*(X-2)*L+X+2 (Y-3)*(X-2)*L+X+3 (Y-3)*(X-2)*L+X+4 ];
ex=[ex (Y-3)*(X-2)*L+L+1  (Y-3)*(X-2)*L+L+2*X+Y-4 (Y-3)*(X-2)*L+L+2*X+Y-3 (Y-3)*(X-2)*L+L+2*X+Y-2 (Y-3)*(X-2)*L+L+X+1 (Y-3)*(X-2)*L+L+X+2 (Y-3)*(X-2)*L+L+X+3 (Y-3)*(X-2)*L+L+X+4 (Y-3)*(X-2)*L+L+X+5]; %����

ex=[ex (Y-3)*(X-2)*L    (Y-3)*(X-2)*L-3 (Y-3)*(X-2)*L-2 (Y-3)*(X-2)*L-1 (Y-3)*(X-2)*L  (Y-3)*(X-2)*L-2*Y+4 (Y-3)*(X-2)*L-2*Y+3 (Y-3)*(X-2)*L-2*Y+2 (Y-3)*(X-2)*L-2*Y+1 ];
ex=[ex (Y-2)*(X-2)*L    (Y-2)*(X-2)*L-2 (Y-2)*(X-2)*L-1 (Y-2)*(X-2)*L (Y-2)*(X-2)*L-2*Y+4 (Y-2)*(X-2)*L-2*Y+3 (Y-2)*(X-2)*L-2*Y+2 (Y-2)*(X-2)*L-2*Y+1];
ex=[ex (Y-2)*(X-2)*L-L  (Y-2)*(X-2)*L-L-2 (Y-2)*(X-2)*L-L-1 (Y-2)*(X-2)*L-L (Y-2)*(X-2)*L-L-2*Y+4 (Y-2)*(X-2)*L-L-2*Y+3 (Y-2)*(X-2)*L-L-2*Y+2 (Y-2)*(X-2)*L-L-2*Y+1 (Y-2)*(X-2)*L-L-2*Y]; %����

ext=[];
exb=[];
% ����Ȧ
for i=2:X-5
    ext=[ext i*L+i-1:i*L+i+3];
    exb=[exb (Y-3)*(X-2)*L+i*L+X+i:(Y-3)*(X-2)*L+i*L+X+i+4];
end

exl=[];
exr=[];
for i=2:Y-5
    exl=[exl i*(X-2)*L+i-1+2*X:i*(X-2)*L+i+3+2*X];
    exr=[exr (2*X-5)*L+(i-1)*(X-2)*L+2*X+Y+i-3:(2*X-5)*L+(i-1)*(X-2)*L+2*X+Y+i+1];
end

exT=[];
exB=[];
%����Ȧ
for i=1:X-4
    exT=[exT (X-2)*L+i*L+i:(X-2)*L+i*L+i+4];
    exB=[exB (Y-4)*(X-2)*L+X+i*L+i:(Y-4)*(X-2)*L+X+i*L+i+4];
end

exL=[];
exR=[];
for i=1:Y-4
    exL=[exL (X-2)*L+(i-1)*L*(X-2)+i-1+2*X+L:(X-2)*L+(i-1)*L*(X-2)+i+3+2*X+L];
    exR=[exR (2*X-5)*L-3+i+2*X+Y+L*(X-2)*(i-1):(2*X-5)*L+i+1+2*X+Y+L*(X-2)*(i-1)];
end

exL(exL==(X-2)*L+2*X+L)=[];
exL(exL==(X-2)*L+(11-1)*L*(X-2)+11+3+2*X+L)=[];

exR(exR==(2*X-5)*L-2+2*X+Y)=[];
exR(exR==(2*X-5)*L+11+1+2*X+Y+L*(X-2)*(11-1))=[];%�ĸ���������


ex=[ex ext exb exl exr exT exB exL exR]';

edgein(ex,:)=[];

%������Ȧ����
tmp=outer(1:X);
tmp=[tmp ; outer(2*X+Y-1:2*X+2*Y-4)];
tmp=[tmp ; outer(2*X:-1:X+1)];
tmp=[tmp ; outer(2*X+Y-2:-1:2*X+1)];
outer=tmp;
edgesboundary=[];

for i=3:L-3
    edgesboundary=[edgesboundary ; outer(i)*ones(L-i-2,1),[outer((i+3):L)]];
end

edgesboundary=[edgesboundary ; outer(1)*ones(L-5,1),[outer((4):(L-2))]];
edgesboundary=[edgesboundary ; outer(2)*ones(L-6,1),[outer((5):(L-2))]];
edgeintra=[[1:N]',[(1:N)+N]'];
edgeintra=[[1:N]',[(1:N)+N+N]'];
 edge=[edges; edgein; edgesO; edgesboundary];
 %edge=[edges; edgesO];
end






