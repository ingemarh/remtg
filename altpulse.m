function altpulse(fig,ax,sig,nsamp,maxlag,slen,nbits,lagincr,r0,c2t)
global dd_data tp tail
tp=slen/nbits;
slen=round(slen/lagincr);
frac=round(slen/nbits);
gating=frac;
%weight=[1/6 (1:(frac-1))/(frac-1/3) 1]; %boxcar filter at dt
weight=[(1:(frac-1))/(frac-1/3) 1];
ngates=nsamp+1-frac-gating; % only lower tail recorded
wdec=ones(frac,1)*(1:nbits); wdec=wdec(:);
wlen=length(wdec);
sacf=zeros(ngates,maxlag+1);

add=sig+1; f1=frac-1;
for lag=1:f1
 plen=nsamp-lag; add2=add+plen;
 lf=gating+frac-lag;
 data=dd_data(add:add2-1);
 data(1:wlen-frac)=data(1:wlen-frac)*wdec(wlen-frac+1)./wdec(1:wlen-frac);
 sacf(:,lag+1)=conv2(data,ones(lf,1),'valid')/(nbits-1)/lf/weight(lag);
 add=add2;
end
for lag=frac:frac:maxlag
 plen=nsamp-lag; add2=add+plen;
 lf=gating;
 data=dd_data(add:add2-1);
 data(1:wlen-lag)=data(1:wlen-lag)*wdec(wlen-lag+1)./wdec(1:wlen-lag);
 sacf(1+lag-frac:end,lag+1)=conv2(data,ones(lf,1),'valid')/lf/(nbits-lag/frac);
 add=add2;
 for flag=(lag+1):(lag+frac-1)
  plen=nsamp-flag;
  if flag<(nbits-1)*frac
   w=[weight(frac-(flag-lag)) weight(flag-lag)];
   ii=[-1 1];
  else
   w=weight(frac-(flag-lag));
   ii=-1;
  end
  sw=sum(w.^2);
  for i=ii
   add2=add+plen;
   lf=gating+frac/2+i*(frac/2-(flag-lag));
   data=dd_data(add:add2-1);
   data(1:wlen-lag-(i+1)/2*frac)=data(1:wlen-lag-(i+1)/2*frac)*wdec(wlen-lag-(i+1)/2*frac+1)./wdec(1:wlen-lag-(i+1)/2*frac);
   data=conv2(data,ones(lf,1),'valid')/lf/(nbits-lag/frac-i/2-.5);
   if i<0
    sacf(1+lag:end-flag+lag,flag+1)=sacf(1+lag:end-flag+lag,flag+1)+data(1+frac-(flag-lag):end)*w(1)/sw;
    sacf(1+flag-frac:lag,flag+1)=data(1:frac-(flag-lag))/w(1);
   else
    sacf(1+lag:end-flag+lag,flag+1)=sacf(1+lag:end-flag+lag,flag+1)+data(1:end-flag+lag)*w(2)/sw;
    sacf(end-flag+lag+1:end,flag+1)=data(end-flag+lag+1:end)/w(2);
   end
   add=add2;
  end
 end
end
pick=round((1-tail)*(slen-2*frac+1)+1):gating:ngates;
if r0==0
 % display only uneven no of gates
 if rem(length(pick),2)==0, pick=pick(1:end-1)+round(gating/2); end
 r0=(1-length(pick)*gating)/2*lagincr;
else
 r0=r0+(-slen+frac*1.5+gating/2+pick(1)-1.5)*lagincr;
end
sacf=sacf(pick,:);
%sacf=sum(sacf);
ngates=size(sacf,1);
if frac>4
 frac=max(frac,6);
 nf=fix(frac/2);
 sacf(:,1)=1;
 for i=1:ngates
  p=polyval(polyfit([1:frac-1].^2,abs([sacf(i,2:frac)]),1),(0:nf-1).^2);
  ang=angle(sacf(i,1:nf));
  sacf(i,1:nf)=p.*exp(j*ang);
 end
else
 sacf(:,1)=(4*abs(sacf(:,2))-abs(sacf(:,3)))/3;
end
h=spitspec(fig,ax,c2t*sacf.',(0:maxlag)*lagincr,lagincr*gating,r0);
set(h,'string','Alternating code')
