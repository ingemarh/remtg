function fftpulse(fig,ax,add,nfft,lagincr,tsys,slen,ngates,r0)
global dd_data tp
if nargin<7
 bacf=ifft(dd_data(add+(1:nfft)));
 h=spitspec(fig,ax,ones(nfft,1)*(tsys(1)./bacf(1,:)).*bacf,(0:(nfft-1))*lagincr);
 set(h,'string','Background')
else % Not yet tested!!
 tp=slen;
 c2t=tsys;
 sacf=ifft(reshape(dd_data(add+(1:nfft*ngates)),nfft,ngates));
 w=round(slen/lagincr); w=(w:-1:0)/w;
 sacf=sacf.*(w(1:nfft)*ones(1,ngates));
 if r0>0
  r0=r0-slen/2+(nfft-1)*lagincr; % check this!!!
 end
 h=spitspec(fig,ax,c2t*sacf,(0:(nfft-1))*lagincr,nfft*lagincr,r0);
 set(h,'string','Long pulse')
end
