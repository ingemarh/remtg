function sacf=longpulse(fig,ax,sig,len,maxlag,slen,bacf,lagincr,r0,c2t)
global dd_data tp site
if site<5
 tail=.7;
else
 tail=0;
end
tp=slen;
nh=len-2*maxlag;
vi=round(slen/lagincr/2);
ngates=floor(nh/vi);
add=sig+1;
w=round(slen/lagincr); w=(w:-1:1)/w;
if tail & vi<=maxlag
 sacf=zeros((maxlag+1),ngates+2); % only one tailgate in each end
 ib=2;
else
 sacf=zeros((maxlag+1),ngates);
 ib=1;
end
for lag=0:maxlag
 if ib==2
  dr=[-lag vi]+maxlag-vi;
  if dr(1)<0
   dr(2)=dr(2)+dr(1); dr(1)=0;
  end
  if diff(dr)>=0
   for i=[0 ngates+1]
    sacf(lag+1,i+1)=(mean(dd_data((dr(1):dr(2))+add+i*vi))-bacf(lag+1))/w(lag+1);
   end
  end
 end
 for i=0:ngates-1
  sacf(lag+1,i+ib)=(mean(dd_data((0:(vi+lag))+add+maxlag-lag+i*vi))-bacf(lag+1))/w(lag+1);
 end
 add=add+len; len=len-1;
end
if r0>0
 %r0=r0-slen/2+(maxlag+vi/2-1)*lagincr;
 r0=r0-slen/2+(vi*(1-ib)+maxlag+vi/2-1)*lagincr;
end

h=spitspec(fig,ax,c2t*sacf,(0:maxlag)*lagincr,vi*lagincr,r0);
set(h,'string','Long pulse')
