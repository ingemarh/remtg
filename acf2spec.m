function [f,w]=acf2spec(acf,lag,m)
[k,l]=size(acf);
if nargin<3
 m=1:l;
end
% add window
for mm=m
 kkk=find(acf(:,mm)==0);
 if isempty(kkk), kk=k; else, kk=kkk(1); end
 wind=hamming(2*kk); acf(1:kk,mm)=acf(1:kk,mm).*wind(kk+1:end);
end
sp=real(fft([acf(:,m);conj(acf(k:-1:2,m))]));
f=[sp((k+1):(2*k-1),:);sp(1:k,:)];
k=k-1;
if nargin==3
 plot(0:k,real(acf(:,m)),'r',0:k,imag(acf(:,m)),'g',-k:k,f/sqrt(2*k+1),'b')
 grid
end
if nargin>1
 df=1/mean(diff(lag)); w=(-k:k)*df/(2*k+1); f=f/df;
end
