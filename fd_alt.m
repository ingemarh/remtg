function fd_alt(fig,ax,sig,ngates,maxlag,slen,nbits,lagincr,r0,c2t)
global dd_data tp
tp=slen/nbits;
slen=round(slen/lagincr);
frac=round(slen/nbits);
%weight=[1/6 (1:(frac-1))/(frac-1/3) 1]; %boxcar filter at dt
weight=[(1:(frac-1))/(frac-1/3) 1];
sacf=reshape(dd_data(sig+(1:ngates*maxlag),maxlag,ngates));

nr=ceil(maxlag/length(w1));
w1=[weight fliplr(weight(1:end-1)) 0];
w1=repmat(w1,1,nr); w2=[zeros(1,frac) w1];
m1=[1:frac-1 frac:-1:0];
m1=repmat(m1,1,nr); m2=[zeros(1,frac) m1];

w=w1(1:maxlag).*m1(1:maxlag)+w2(1:maxlag).*m2(1:maxlag);
sacf=[zeros(1,ngates) sacf./(w'*ones(1,ngates))];

if r0==0
 r0=(1-ngates)/2*lagincr*frac;
else
 r0=r0-slen;
end
if frac>4
 frac=max(frac,6);
 nf=fix(frac/2);
 sacf(:,1)=1;
 for i=1:ngates
  p=polyval(polyfit([1:frac-1].^2,abs([sacf(2:frac,i)]),1),(0:nf-1).^2);
  ang=angle(sacf(1:nf,i));
  sacf(1:nf,i)=p.*exp(j*ang);
 end
else
 sacf(1,:)=(4*abs(sacf(2,:))-abs(sacf(3,:)))/3;
end
h=spitspec(fig,ax,c2t*sacf,(0:maxlag)*lagincr,lagincr*frac,r0);
set(h,'string','Alternating code')
