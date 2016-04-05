function fd_alt(fig,ax,sig,ngates,maxlag,slen,nbits,lagincr,r0,c2t,sig0)
global dd_data tp local
tp=slen/nbits;
slen=round(slen/lagincr);
frac=round(slen/nbits);
if nbits==1
 sacf=reshape(dd_data(sig+(1:ngates*(maxlag+1))),ngates,maxlag+1).';
 weight=[1 ([(maxlag-1):-1:1 1/6])/(maxlag-1/3)];
 sacf=sacf./(weight(1:maxlag+1)'*ones(1,ngates));
 if r0==0
  r0=(1-ngates)/2*lagincr*frac;
 else
  r0=r0-(slen/2+1-maxlag/2)*lagincr;
 end
else
 weight=[1/6/frac (1:(frac-1))/(frac-1/3) 1]; %boxcar filter at dt
 sacf=reshape(dd_data(sig+(1:ngates*maxlag)),ngates,maxlag).';
 sacf=[zeros(1,ngates);sacf];
 shacf=reshape(dd_data(sig0+(1:(ngates+1)*frac)),ngates+1,frac).';
 sacf(1:frac,:)=sacf(1:frac,:)+conv2(shacf,[1 1],'valid');

 w1=[weight(2:end) fliplr(weight(2:end-1)) 0];
 nr=ceil(maxlag/length(w1));
 w1=repmat(w1,1,nr)'; w2=[zeros(frac+1,1);w1]; w1=[weight(1);w1];
 m=[1:frac-1 frac:-1:0];
 m1=m(:)*(nbits-1:-2:0); m2=m(:)*(nbits-2:-2:-1);
 m1=[(nbits-1)*[frac*2:-1:frac] m1(frac+1:end)]'; m2=[zeros(frac+1,1);m2(:)];

 w=w1(1:maxlag+1).*m1(1:maxlag+1)+w2(1:maxlag+1).*m2(1:maxlag+1);
 d=find(w>0);
 sacf=sacf(d,:)./(w(d)*ones(1,ngates));

 %sacf=sum(sacf,2);
 if frac>600
  nff=min(frac,6);
  nf=fix(nff/2);
  for i=1:ngates
   p=polyval(polyfit([1:nff-1]'.^2,abs(sacf(2:nff,i)),1),(0:nf-1)'.^2);
   ang=mean(angle(sacf(2:nff,i))./[1:nff-1]')*[0:nf-1]';
   sacf(1:nf,i)=p.*exp(j*ang);
  end
 elseif frac>500 & local.ver>=7
  nf=find(w(1:frac)<mean(w)/3); nf=nf(end);
  s=[0 1 0]; x=[0:nf-1]'; b=w(x+1).^2; b(1:2)=0;
  for i=1:ngates
   a=sacf(x+1,i);
   %s=fminsearch(@(s) racf(s,x,a,b),s,optimset('display','off'));
   sacf(x+1,i)=racf(s,x);
  end
 else
  sacf(1,:)=(4*abs(sacf(2,:))-abs(sacf(3,:)))/3;
 end
 ngates=size(sacf,2);
 if r0==0
  r0=(1-ngates)/2*lagincr*frac;
 else
  r0=r0-(frac+1)*lagincr;
 end
end
%sacf=sacf(:,1);
h=spitspec(fig,ax,c2t*sacf,(0:maxlag)*lagincr,lagincr*frac,r0);
set(h,'string','Alternating code')

function err=racf(s,x,y,w)
s=2*sinh(s);
err=s(1)^2./(1+(x/s(2)).^2).*exp(i*s(3)*x);
%err=s(1)./(1+(x/s(2)).^2).*exp(i*s(3)*x);
%err=s(1)./(1+x.^2/s(2)).*exp(i*s(3)*x);
%err=s(1)*exp(-(x/s(2)).^2+i*s(3)*x);
if nargin>2
 err=(err-y).*w;
 err=norm([real(err);imag(err)]);
end

