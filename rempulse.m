function sacf=rempulse(fig,ax,sig,len,maxlag,slen,bacf,lagincr,c2t)
global dd_data
slen=round(slen/lagincr);
if rem(len-slen,2), slen=slen-1; end
add=sig+1+(len-slen)/2;
sacf=zeros((maxlag+1),1);
for lag=0:maxlag
 sacf(lag+1)=mean(dd_data((0:slen)+add));
 add=add+len; slen=slen-1; len=len-1;
end
sacf=sacf-bacf;
h=spitspec(fig,ax,c2t*sacf,(0:maxlag)*lagincr,0);
set(h,'string','Long pulse')
