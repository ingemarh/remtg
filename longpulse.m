function sacf=longpulse(fig,ax,sig,len,maxlag,slen,bacf,lagincr,r0,c2t)
global dd_data tp tail
tp=slen;
nh=len-round(2*maxlag*(1-tail));
vi=round(slen/lagincr/2)+[-1:1];
[d i]=min(rem(nh./vi,1)); vi=vi(i);
ngates=floor(nh/vi);
add=sig+1;
w=round(slen/lagincr); w=(w:-1:1)/w;
sacf=zeros((maxlag+1),ngates);
i1=floor((len-ngates*vi)/2);
for lag=0:maxlag
 for i=0:ngates-1
  dr=[0 vi+lag]+i1-lag+i*vi;
  if dr(1)<0
   dr(2)=sum(dr); dr(1)=0;
  end
  if dr(2)>len-1
   dr(1)=sum(dr)-len+1; dr(2)=len-1;
  end
  if diff(dr)>=0
   sacf(lag+1,i+1)=(mean(dd_data((dr(1):dr(2))+add))-bacf(lag+1))/w(lag+1);
  end
 end
 add=add+len; len=len-1;
end
if r0>0
 r0=r0-slen/2+(i1+vi/2-1)*lagincr;
end

h=spitspec(fig,ax,c2t*sacf,(0:maxlag)*lagincr,vi*lagincr,r0);
set(h,'string','Long pulse')
