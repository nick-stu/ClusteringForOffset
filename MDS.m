function[X]=MDS(data,dNew)
% ����Ϊdata��dNew ������X
% num=size(data,1);
% D=pdist2(data,data);
% B=zeros(num,num);
% for i=1:num
%    for j=1:num
%        dist_ia_2=mean(D(i,:).^2);
%        dist_aj_2=mean(D(:,j).^2);
%        dist_aa_2=sum(sum(D.^2))/(num*num);
%        
%        B(i,j)=-0.5*(D(i,j)^2 - dist_ia_2 - dist_aj_2  + dist_aa_2); %
%    end
% end
% %  ����B������ֵ�Խ���D����������V��ʹBV=VD������
% [V,D] = eigs(B);
% X = V(:,1:dNew) * (D(1:dNew,1:dNew).^(1/2)); 
%%
data=pdist2(data,data);
X=mdscale(data,dNew);
end
% http://www.voidcn.com/article/p-wqtnwmbt-bqt.html