function myalt(fig,ax,sig,nsamp,maxlag,slen,nbits,lagincr,r0,c2t)
global dd_data
slen=slen/lagincr;
frac=round(slen/nbits);
gating=frac;
ngates=floor((nsamp-(nbits+1)*frac)/gating);
ngates=3;
gating=floor((nsamp-(nbits+1)*frac)/ngates);
ssacf=zeros(nbits-1,2*frac+1,ngates);
sacf=zeros(ngates,maxlag+1);
weight=((0:3:(3*frac))+1)/(3*frac+1);

add=sig+1;
if ngates==1
 for lag=frac:frac:(maxlag-1)
  for i=0:(2*frac)
   add2=add+nsamp-frac-i-1;
   ssacf(lag/frac,i+1,1)=mean(dd_data(add:add2))/(nbits-lag/frac);
   add=add2+1;
  end
 end
else
 for lag=frac:frac:(maxlag-1)
  for i=0:frac
   add1=add+frac-1;
   for g=1:ngates
    ssacf(lag/frac,i+1,g)=mean(dd_data(add1+(1:(gating+frac-i))))/(nbits-lag/frac);
    add1=add1+gating;
   end
   add=add+nsamp-frac-i;
  end
  for i=1:frac
   add1=add+frac-1-i;
   for g=1:ngates
    ssacf(lag/frac,i+frac+1,g)=mean(dd_data(add1+(1:(gating+i))))/(nbits-lag/frac);
    add1=add1+gating;
   end
   add=add+nsamp-2*frac-i;
  end
 end
end
for i=1:ngates
 ss=reshape(ssacf(:,:,i),size(ssacf,1),size(ssacf,2));
 sacf(i,1:frac)=ss(1,1:frac)./weight(1:(end-1));
 for lag=1:(nbits-2)
  sacf(i,(0:frac)+lag*frac+1)=(ss(lag,(frac+1):end).*weight(end:-1:1)+ss(lag+1,1:(frac+1)).*weight)./(weight(end:-1:1).^2+weight.^2);
 end
 sacf(i,(1:frac)+(nbits-1)*frac+1)=ss(end,(frac+2):end)./weight((end-1):-1:1);
end
%sacf=sum(sacf);
sacf(:,1)=max(abs(sacf(:,4:801))')';
sacf(:,2)=mean(sacf(:,[1 3])')';
sacf(:,2)=real(mean(sacf(:,[1 2])'))'-j*imag(mean(sacf(:,[2 3])'))';
sacf(:,1)=(4*abs(sacf(:,2))-abs(sacf(:,3)))/1;
h=spitspec(fig,ax,c2t*sacf.',(0:maxlag)*lagincr,lagincr*gating,r0);
set(h,'string','Alternating code')
