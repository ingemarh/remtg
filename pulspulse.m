function sacf=pulspulse(fig,ax,sig,len,maxlag,slen,np,dt,lagincr,wl,p0,wp,r0,c2t)
global dd_data tp
tp=slen;
sacf=reshape(dd_data((sig+1):(sig+len*maxlag)),len,maxlag);
sacf=sacf./(ones(len,1)*(np-((1:maxlag)*wl)));
if isfinite(p0)
 sacf=[abs(dd_data(p0+(1:len)))/wp sacf];
else
 sacf=[(4*sacf(:,1)-sacf(:,2))/3 sacf];
end
if r0>0
 r0=r0-(.5-1)*dt;
else
 r0=(1-len)/2*dt;
end
h=spitspec(fig,ax,c2t*sacf.',(0:maxlag)*lagincr,dt,r0);
set(h,'string','Special pulse')
