function pp(fig,ax,sig,nsamp,siglen,dt,blev,tsys,r0)
global rd d_parbl el bval radcon site
nsig=sum(isfinite(sig));
if nsig==0
 set(ax,'visible','off'), return
end
x=zeros(max(nsamp),nsig); d=x*NaN;
for i=1:nsig
 ld=nsamp(i)-1;
 p=rd((sig(i)+1):(sig(i)+nsamp(i)));
 if isempty(blev)
  b=min(p);
 else
  b=blev(min([i length(blev)]));
 end
 syst=tsys(min([i length(tsys)]));
 d(1:nsamp(i),i)=(p-b)*syst;
 x(1:nsamp(i),i)=(0:ld)'*dt(i)*1e6;
%if i>1 & siglen(i)<siglen(1)
% d(1:nsamp(i),i)=conv2(d(1:nsamp(i),i),ones(floor(siglen(1)/dt(i)),1)/(siglen(1)/siglen(i)),'same');
%end
end
yl='Power (K)';
if isfinite(r0(1:nsig))
 x=(x+ones(max(nsamp),1)*(r0(1:nsig)-siglen(1:nsig)/2-dt(1:nsig))*1e6)*.15;
 if bval(11)
  if d_parbl(8)>100e3
   d=d.*x.^2.*(ones(max(nsamp),1)*(2*radcon(site)/d_parbl(8)*dt(1:nsig)./siglen(1:nsig)));
  else
   d=d*0;
  end
  yl='Density (m^{-3})';
 end
 re=6370; x=x/re; x=re*sqrt(1+x.*(x+2*sin(el/57.2957795)))-re;
 xl='Altitude (km)';
else
 xl='\mus';
end
updateplot(fig,ax,x,d)
set(get(ax,'xlabel'),'string',xl)
set(get(ax,'ylabel'),'string',yl)
