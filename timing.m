function timing(fig,ax,sig,nsamp,siglen,dt,blev,tsys)
global rd
nsig=length(sig);
if nsig==0
 set(ax,'visible','off'), return
end
x=zeros(max(nsamp),nsig); d=x*NaN; snr=[];
for i=1:nsig
 ld=nsamp(i)-1;
 p=rd((sig(i)+1):(sig(i)+nsamp(i)));
 y=[ceil((ld-siglen(i)/dt(i))/2) floor((ld+siglen(i)/dt(i))/2)]+1;
 if isempty(blev)
  b=median(p([1:(y(1)-1) (y(2)+1):nsamp(i)]));
 else
  b=blev(min([i length(blev)]));
 end
 syst=tsys(min([i length(tsys)]));
 snr=[snr median(p(y(1):y(2)))/b-1];
 d(1:nsamp(i),i)=(p-b)*syst;
 x(1:nsamp(i),i)=(-ld/2:ld/2)'*dt(i)*1e6;
end
if nsig==1
 s=snr; if snr<.05, s=0.05; end
 filltime=30e-6+1.5*dt;
 y=[siglen-filltime siglen+filltime ld*dt]/2*1e6; y=[-y(3:-1:1) y];
 pshape=[0 0 s s 0 0];
 updateplot(fig,ax,x,d,y,pshape*syst*b)
 tri=conv(d,interp1(y,pshape,x));
 [m,p]=max(tri);
 del=(p-(length(tri)+1)/2)*dt;
 if snr<0, del=NaN; end
 h=get(ax,'title');
 set(h,'string',(sprintf('SNR=%.1f%% Delay=%.0f\\mus',100*snr,del*1e6)))
else
 updateplot(fig,ax,x,d)
 h=get(ax,'title');
 set(h,'string',(sprintf('SNR=[%.1f %.1f]%%',100*snr,del*1e6)))
end
h=get(ax,'xlabel');
set(h,'string',('\mus'))
h=get(ax,'ylabel');
set(h,'string',('Power (K)'))
set(ax,'visible','on')
