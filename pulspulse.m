function sacf=pulspulse(fig,ax,sig,len,maxlag,slen,np,dt,lagincr,wl,p0,wp,r0,c2t,transp)
global dd_data tp rd
tp=slen;
if isempty(transp)
 sacf=reshape(dd_data((sig+1):(sig+len*maxlag)),len,maxlag);
else
 sacf=transpose(reshape(dd_data((sig+1):(sig+len*maxlag)),maxlag,len));
end
sacf=sacf./(ones(len,1)*(np-((1:maxlag)*wl)));
if isfinite(p0)
 sacf=[rd(p0+(1:len))/wp sacf];
elseif isempty(transp)
 sacf=[(4*sacf(:,1)-sacf(:,2))/3 sacf];
end
if r0~=0
 r0=r0-dt;
else
 r0=(1-len)/2*dt;
end
h=spitspec(fig,ax,c2t*sacf.',(0:maxlag)*lagincr,dt,r0);
set(h,'string','Special pulse')
