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
if all(imag(acf(k,m))==0)
 sp=real(fft([acf(1:k-1,m);conj(acf(k:-1:2,m))]));
 k=k-1;
else
 sp=real(fft([acf(1:k,m);zeros(1,length(m));conj(acf(k:-1:2,m))]));
end
f=[sp(k+1:2*k,:);sp(1:k,:)];
if nargin>1
 df=1/mean(diff(lag)); w=(-k:k-1)*df/(2*k); f=f/df;
end
