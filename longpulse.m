function sacf=longpulse(fig,ax,sig,len,maxlag,slen,bacf,lagincr,r0,c2t)
global dd_data tp
tp=slen;
nh=len-2*maxlag;
vi=round(slen/lagincr/2);
ngates=floor(nh/vi);
add=sig+1;
sacf=zeros((maxlag+1),ngates);
w=round(slen/lagincr); w=(w:-1:1)/w;
for lag=0:maxlag
 for i=0:ngates-1
  sacf(lag+1,i+1)=(mean(dd_data((0:(vi+lag))+add+maxlag-lag+i*vi))-bacf(lag+1))/w(lag+1);
 end
 add=add+len; len=len-1;
end
if r0>0
 r0=r0-slen/2+(maxlag+vi/2-1)*lagincr;
end

h=spitspec(fig,ax,c2t*sacf,(0:maxlag)*lagincr,vi*lagincr,r0);
set(h,'string','Long pulse')
