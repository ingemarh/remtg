function bacf=backspec(fig,ax,maxlag,maxlagb,back,nsamp,lagincr,tsys)
global dd_data
ncal=length(back);
bacf=zeros((maxlag+1),ncal);
for i=1:ncal
 add=back(i)+1; len=nsamp(i)-1;
 for lag=0:maxlagb
  bacf(lag+1,i)=meddan(dd_data(add:(add+len)));
  add=add+len+1; len=len-1;
 end
end
h=spitspec(fig,ax,ones(maxlag+1,1)*(tsys(1:ncal)./bacf(1,:)).*bacf,(0:maxlag)*lagincr);
set(h,'string','Background')
if ncal>1, bacf=mean(bacf')'; end

function m=meddan(x)
m=median(real(x))+i*median(imag(x));
