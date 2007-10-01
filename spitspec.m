function h=spitspec(fig,ax,sacf,lag,dt,r0)
global bval d_parbl gating el site combine combhold maxsize_acf selax
if nargin<6, r0=0; end
if ~isempty(selax) & all(selax.fig==[fig ax])
 selax.sacf=sacf; selax.lag=lag;
 if nargin>4
  selax.dt=dt; selax.r0=r0;
 end
end
sgating=gating;
[nlags,ngates]=size(sacf);
if nlags>maxsize_acf(1)
 nlags=maxsize_acf(1);
 sacf=sacf(1:nlags,:); lag=lag(1:nlags);
end
if ngates/sgating>maxsize_acf(2)
 sgating=ceil(ngates/maxsize_acf(2));
end
if sgating>1
 ngates=floor(ngates/sgating);
 sacf=reshape(sum(reshape(sacf(:,1:(ngates*sgating))',sgating,ngates,nlags)),ngates,nlags)';
end
waterlim=[5 8];
if bval(11)==1 & ngates>waterlim(2) & r0>0
 h=qfit(fig,ax,sacf,lag,dt,r0); return
elseif bval(11)==1 & nargin>4 & (site==5 | site==6)
 [s,w]=max(sacf(1,:));
 par=qfit(fig,ax,sacf(:,w),lag,0,1e-2);
end 
fsc=1000;
if bval(7)~=1
 [s,w]=acf2spec(sacf,lag);
 s=s*1000;
 if max(w)<fsc, fsc=1; end
 w=w/fsc;
elseif ngates>1
 s=real(sacf);
 if max(lag)*fsc>1, fsc=1; end
 w=lag*fsc*1e3;
else
 s=[real(sacf) imag(sacf)];
 if max(lag)*fsc>1, fsc=1; end
 w=lag*fsc*1e3;
end
if ngates<waterlim(1)
 updateplot(fig,ax,w,s);
 h=get(ax,'ylabel');
else
 if bval(7)~=1, s(find(s<0))=0; end
 r=(r0+(0:(ngates-1))*dt*sgating)*1e6;
 if r0>0
  r=r*.15;
  re=6370; r=r/re; r=re*sqrt(1+r.*(r+2*sin(el/57.2957795)))-re;
 end
 if ~isempty(combhold)
  dr=diff(r(1:2)); n=round((r(1)-combhold.r(end))/dr)-1;
  s=interp2(r,w',s,r,combhold.w');
  r=[combhold.r (1:n)*dr+combhold.r(end) r];
  s=[combhold.s NaN*ones(length(combhold.w),n) s];
  ngates=length(r); combhold=[];
 end
 if ~isempty(combine) & any(combine==ax)
  combhold.s=s; combhold.r=r; combhold.w=w;
  d=find(combine==ax); combine(d(1))=1;
  h=[]; return
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
 if fsc==1000
  set(get(ax,'xlabel'),'string','Frequency (kHz)')
 else
  set(get(ax,'xlabel'),'string','Frequency (Hz)')
 end
 set(ax,'xgrid','on','ygrid','on')
else
 set(h,'string','Power (K)')
 if fsc==1000
  set(get(ax,'xlabel'),'string','Lag (\mus)')
 else
  set(get(ax,'xlabel'),'string','Lag (ms)')
 end
 set(ax,'xgrid','off','ygrid','on')
end
h=get(ax,'title');
set(ax,'visible','on')
if bval(11)==1 & nargin>4 & (site==5 | site==6)
 set(h,'string',sprintf('%.0fK %.0fK %.0fms^{-1}',par))
 h=get(ax,'zlabel');
end
