function bacf=backspec(fig,ax,maxlag,maxlagb,back,nsamp,nfft,lagincr,tsys)
global dd_data rd
ncal=sum(isfinite(back));
mlag=max([maxlag maxlagb nfft-1]);
bacf=zeros(mlag+1,ncal);
for i=1:ncal
 if nsamp(i)>0
  add=back(i)+1; len=nsamp(i)-1;
  for lag=0:maxlagb
   bacf(lag+1,i)=meddan(dd_data(add:(add+len)));
   add=add+len+1; len=len-1;
  end
 elseif isfinite(nfft(i))
  bacf(1:nfft(i),i)=ifft(rd(back(i)+(1:nfft(i))));
 end
end
h=spitspec(fig,ax,ones(mlag+1,1)*(tsys(1:ncal)./bacf(1,:)).*bacf,(0:mlag)*lagincr);
set(h,'string','Background')
ncal=find(nsamp);
if ~isempty(ncal), bacf=mean(bacf(1:maxlag+1,ncal),2); end

function m=meddan(x)
xr=real(x); xi=imag(x);
mr=median(xr); mi=median(xi);
m=mean(xr(find(abs(xr-mr)<=std(xr))))+i*mean(xi(find(abs(xi-mi)<=std(xi))));
