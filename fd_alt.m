function fd_alt(fig,ax,sig,ngates,maxlag,slen,nbits,lagincr,r0,c2t)
global dd_data tp
tp=slen/nbits;
slen=round(slen/lagincr);
frac=round(slen/nbits);
if nbits==1
 sacf=reshape(dd_data(sig+(1:ngates*(maxlag+1))),maxlag+1,ngates);
 weight=[1 ((maxlag-1):-1:1)/(maxlag-1/3) 1/6/maxlag];
 sacf=sacf./(weight(1:maxlag+1)'*ones(1,ngates));
 if r0==0
  r0=(1-ngates)/2*lagincr*frac;
 else
  r0=r0-(slen/2+1-maxlag/2)*lagincr;
 end
else
%weight=[1/6 (1:(frac-1))/(frac-1/3) 1]; %boxcar filter at dt
 weight=[(1:(frac-1))/(frac-1/3) 1];
 sacf=reshape(dd_data(sig+(1:ngates*maxlag)),maxlag,ngates);

 w1=[weight fliplr(weight(1:end-1)) 0];
 nr=ceil(maxlag/length(w1));
 w1=repmat(w1,1,nr)'; w2=[zeros(frac,1);w1];
 m=[1:frac-1 frac:-1:0]';
 m1=m*(nbits-1:-2:1); m2=m*(nbits-2:-2:1);
 m1=m1(:); m2=[zeros(frac,1);m2(:)];

 w=w1(1:maxlag).*m1(1:maxlag)+w2(1:maxlag).*m2(1:maxlag);
 sacf=[zeros(1,ngates);sacf./(w*ones(1,ngates))];

 if frac>4
  nff=max(frac,6);
  nf=fix(nff/2);
  sacf(1,:)=1;
  for i=1:ngates
   p=polyval(polyfit([1:nff-1]'.^2,abs([sacf(2:nff,i)]),1),(0:nf-1)'.^2);
   ang=angle(sacf(1:nf,i));
   sacf(1:nf,i)=p.*exp(j*ang);
  end
 else
  sacf(1,:)=(4*abs(sacf(2,:))-abs(sacf(3,:)))/3;
 end
 if r0==0
  r0=(1-ngates)/2*lagincr*frac;
 else
  r0=r0-(frac+1)*lagincr;
 end
end
h=spitspec(fig,ax,c2t*sacf,(0:maxlag)*lagincr,lagincr*frac,r0);
set(h,'string','Alternating code')
