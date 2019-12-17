function W = Ncalcweights4mr(input_img, superpixels, spno, theta,img2,img3)
% Function W = calcweights4mr(input_img, superpixels, spno, theta)
% calculates the weight matrix for manifold-ranking-based background and
% foreground saliency approximations.
% 
% Inputs:       input_img - the input RGB image
%                   superpixels - the superpixel segmentation result
%                   spno - total superpixel number
%                   theta - controlling parameter
% Outputs:    W - the weight matrix
% 
% 11/05/14 - by Yuchen Yuan
% Based on the paper:
% Changyang Li, Yuchen Yuan, Weidong Cai, Yong Xia, and David Dagan Feng. 
% "Robust Saliency Detection via Regularized Random Walks Ranking". CVPR 2015
disp('calcweights4mr')
    if nargin < 4
        theta = 10;
    end
    
    [m,n,k] = size(input_img);
    
% Calculate average Lab value of each superpixel
    input_pixels=reshape(input_img, m*n, k);
    sp_rgb=zeros(spno,1,3);
    for i=1:spno
        sp_rgb(i,1,:)=mean(input_pixels((superpixels==i),:),1);
    end  
    sp_lab = colorspace('Lab<-', sp_rgb); 
    sp_lab=reshape(sp_lab,spno,3);
    
    input_pixels=reshape(img2, m*n, k);
    sp_rgb=zeros(spno,1,3);
    for i=1:spno
        sp_rgb(i,1,:)=mean(input_pixels((superpixels==i),:),1);
    end  
    sp_lab2 = colorspace('Lab<-', sp_rgb); 
    sp_lab2=reshape(sp_lab2,spno,3);
    
    sp_lab=[sp_lab; sp_lab2];
    
     input_pixels=reshape(img3, m*n, k);
    sp_rgb=zeros(spno,1,3);
    for i=1:spno
        sp_rgb(i,1,:)=mean(input_pixels((superpixels==i),:),1);
    end  
    sp_lab3 = colorspace('Lab<-', sp_rgb); 
    sp_lab3=reshape(sp_lab3,spno,3);
    
    sp_lab=[sp_lab; sp_lab3];
     
% Calculate edges    
    neighbourhood = zeros(3*spno);
    for i = 1:m-1
        for j = 1:n-1
            if(superpixels(i,j)~=superpixels(i,j+1))
                neighbourhood(superpixels(i,j),superpixels(i,j+1)) = 1;
                neighbourhood(superpixels(i,j+1),superpixels(i,j)) = 1;
                neighbourhood(superpixels(i,j)+spno,superpixels(i,j+1)+spno) = 1;
                neighbourhood(superpixels(i,j+1)+spno,superpixels(i,j)+spno) = 1;
                neighbourhood(superpixels(i,j)+spno+spno,superpixels(i,j+1)+spno+spno) = 1;
                neighbourhood(superpixels(i,j+1)+spno+spno,superpixels(i,j)+spno+spno) = 1;
            end;
            if(superpixels(i,j)~=superpixels(i+1,j))
                neighbourhood(superpixels(i,j),superpixels(i+1,j)) = 1;
                neighbourhood(superpixels(i+1,j),superpixels(i,j)) = 1;
                neighbourhood(superpixels(i,j)+spno,superpixels(i+1,j)+spno) = 1;
                neighbourhood(superpixels(i+1,j)+spno,superpixels(i,j)+spno) = 1;
                neighbourhood(superpixels(i,j)+spno+spno,superpixels(i+1,j)+spno+spno) = 1;
                neighbourhood(superpixels(i+1,j)+spno+spno,superpixels(i,j)+spno+spno) = 1;
            end;
            if(superpixels(i,j)~=superpixels(i+1,j+1))
                neighbourhood(superpixels(i,j),superpixels(i+1,j+1)) = 1;
                neighbourhood(superpixels(i+1,j+1),superpixels(i,j)) = 1;
                neighbourhood(superpixels(i,j)+spno,superpixels(i+1,j+1)+spno) = 1;
                neighbourhood(superpixels(i+1,j+1)+spno,superpixels(i,j)+spno) = 1;
                neighbourhood(superpixels(i,j)+spno+spno,superpixels(i+1,j+1)+spno+spno) = 1;
                neighbourhood(superpixels(i+1,j+1)+spno+spno,superpixels(i,j)+spno+spno) = 1;
            end;
            if(superpixels(i+1,j)~=superpixels(i,j+1))
                neighbourhood(superpixels(i+1,j),superpixels(i,j+1)) = 1;
                neighbourhood(superpixels(i,j+1),superpixels(i+1,j)) = 1;
                neighbourhood(superpixels(i+1,j)+spno,superpixels(i,j+1)+spno) = 1;
                neighbourhood(superpixels(i,j+1)+spno,superpixels(i+1,j)+spno) = 1;
                neighbourhood(superpixels(i+1,j)+spno+spno,superpixels(i,j+1)+spno+spno) = 1;
                neighbourhood(superpixels(i,j+1)+spno+spno,superpixels(i+1,j)+spno+spno) = 1;
            end;
        end;
    end;    
    
    bd=unique([superpixels(1,:),superpixels(m,:),superpixels(:,1)',superpixels(:,n)']);
    for i=1:length(bd)
        for j=i+1:length(bd)
            neighbourhood(bd(i),bd(j))=1;
            neighbourhood(bd(j),bd(i))=1;
        end
    end

    edges=[];
    for i=1:3*spno
        indext=[];
        ind=find(neighbourhood(i,:)==1);
        for j=1:length(ind)
            indj=find(neighbourhood(ind(j),:)==1);
            indext=[indext,indj];
        end
        indext=[indext,ind];
        indext=indext((indext>i));
        indext=unique(indext);
        if(~isempty(indext))
            ed=ones(length(indext),2);
            ed(:,2)=i*ed(:,2);
            ed(:,1)=indext;
            edges=[edges;ed];
        end
    end

    
    
    
    
    
    
    
    
    
    
    
    
    
% Calculate weight matrix
    weights=exp(-theta*normalize(sqrt(sum((sp_lab(edges(:,1),:)-sp_lab(edges(:,2),:)).^2,2))));
    W=sparse([edges(:,1);edges(:,2)],[edges(:,2);edges(:,1)],[weights;weights],3*spno,3*spno);
    for i=1:spno
    W(i,i+spno)=5;
    W(i+spno,i)=5;
    W(i,i+2*spno)=5;
    W(i+2*spno,i)=5;
    end
    
end
