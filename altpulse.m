function altpulse(fig,ax,sig,nsamp,maxlag,slen,nbits,lagincr,r0,c2t)
global dd_data tp
tp=slen/nbits;
slen=round(slen/lagincr);
frac=round(slen/nbits);
gating=frac;
weight=((2:2:(2*frac))+1)/(2*frac+1);
ngates=nsamp-slen+2-gating;
sacf=zeros(ngates,maxlag+1);

add=sig+1; f1=frac-1;
for lag=1:f1
 plen=nsamp-lag; add2=add+plen;
 lf=gating+frac-lag;
 sacf(:,lag+1)=conv2(dd_data(add2-ngates-lf+1-f1:add2-1-f1),ones(lf,1),'valid')/(nbits-1)/lf/weight(lag);
 add=add2;
end
for lag=frac:frac:maxlag
 plen=nsamp-lag; add2=add+plen;
 lf=gating;
 sacf(:,lag+1)=conv2(dd_data(add2-ngates-lf+1-f1:add2-1-f1),ones(lf,1),'valid')/lf/(nbits-lag/frac);
 add=add2;
 for flag=(lag+1):(lag+frac-1)
  plen=nsamp-flag;
  if flag<(nbits-1)*frac
   w=weight(flag-lag)+weight(frac-(flag-lag));
   ii=[-1 1];
  else
   w=weight(frac-(flag-lag));
   ii=-1;
  end
  for i=ii
   add2=add+plen;
   lf=gating+frac/2+i*(frac/2-(flag-lag));
   shift=f1-(1-i)/2*(flag-lag);
   sacf(:,flag+1)=sacf(:,flag+1)+conv2(dd_data(add2-ngates-lf+1-shift:add2-1-shift),ones(lf,1),'valid')/lf/(nbits-lag/frac-i/2-.5)/w;
   add=add2;
  end
 end
end
if r0<0
 pick=(rem(floor((ngates-1)/2),gating)+1):gating:ngates;
 r0=(1-ngates)/2*lagincr;
else
 pick=1:gating:ngates;
 if r0>0
  r0=r0-(slen/nbits/2-1+gating/2)*lagincr;
 end
end
sacf=sacf(pick,:);
%sacf=sum(sacf);
ngates=size(sacf,1);
sacf(:,1)=(4*abs(sacf(:,2))-abs(sacf(:,3)))/3;
h=spitspec(fig,ax,c2t*sacf.',(0:maxlag)*lagincr,lagincr*gating,r0);
set(h,'string','Alternating code')
