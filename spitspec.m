function h=spitspec(fig,ax,sacf,lag,dt,r0)
global bval d_parbl gating el site
if nargin<6, r0=0; end
ngates=size(sacf,2);
if gating>1
 nlags=size(sacf,1);
 ngates=floor(ngates/gating);
 sacf=reshape(sum(reshape(sacf(:,1:(ngates*gating))',gating,ngates,nlags)),ngates,nlags)';
end
waterlim=[4 8];
if bval(11)==1 & ngates>waterlim(2) & r0>0
 h=qfit(fig,ax,sacf,lag,dt,r0); return
elseif bval(11)==1 & nargin>4 & site<3
 [s,w]=max(sacf(1,:));
 par=qfit(fig,ax,sacf(:,w),lag,0,1e-2);
end 
if bval(7)~=1
 [s,w]=acf2spec(sacf,lag);
 s=s*1000;
 w=w/1000;
elseif ngates>1
 s=real(sacf);
 w=lag*1e6;
else
 s=[real(sacf) imag(sacf)];
 w=lag*1e6;
end
if ngates<waterlim(1)
 updateplot(fig,ax,w,s);
 h=get(ax,'ylabel');
else
 if bval(7)~=1, s(find(s<0))=0; end
 r=(r0+(0:(ngates-1))*dt*gating)*1e6;
 if r0>0
  r=r*.15;
  re=6370; r=r/re; r=re*sqrt(1+r.*(r+2*sin(el/57.2957795)))-re;
 end
 if ngates<waterlim(2) | get(ax,'view')-[0 90]
  updatewater(fig,ax,w,r,s')
 else
  updateimage(fig,ax,w,r,s')
 end
 h=get(ax,'ylabel');
 if r0>0
  set(h,'string','Altitude (km)')
 else
  set(h,'string','\mus')
 end
 h=get(ax,'zlabel');
end
if bval(7)~=1
 set(h,'string','Power (K/kHz)')
 set(get(ax,'xlabel'),'string','Frequency (kHz)')
 set(ax,'xgrid','on','ygrid','on')
else
 set(h,'string','Power (K)')
 set(get(ax,'xlabel'),'string','Lag (\mus)')
 set(ax,'xgrid','off','ygrid','on')
end
h=get(ax,'title');
set(ax,'visible','on')
if bval(11)==1 & nargin>4 & site<3
 set(h,'string',sprintf('%.0fK %.0fK %.0fms^{-1}',par))
 h=get(ax,'zlabel');
end
