function tx(fig,name,head,s,nsam,npul,dt)
global d_raw
np=length(s);
i=[1 1;2 1;3 1;2 2];
a=getaxes(fig,i(np,1),i(np,2),name,head);
tx=abs(d_raw); ang=angle(d_raw)*180/pi;
for n=1:np
 raw=reshape(d_raw(s(n)+(1:nsam(n)*npul(n))),nsam(n),npul(n));
 tx=abs(raw).^2; mtx=max(tx(:));
 if mtx>3000
  tx=tx./10^(fix(log10(mtx)-2));
 end
 ang=angle(raw)*180/pi;
 sang=sort(ang(:));
 ang=ang-sang(end/4);
 t=(0:nsam(n)-1)'*dt(n)*1e6;
 updateplot(fig,a(n),t,[tx ang],[])
 set(get(a(n),'xlabel'),'string','\mus')
end
