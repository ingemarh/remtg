function h=qfit(fig,ax,sacf,lag,dt,r0)
global d_parbl el gating site tp radcon
ngates=size(sacf,2);
nlags=size(sacf,1);
r=(r0+(0:(ngates-1))*dt*gating)*1e6;
r=r*.15;
re=6370; a=r/re; a=re*sqrt(1+a.*(a+2*sin(el/57.2957795)))-re;

pt=max([d_parbl(8) 1]);
qf=[]; al=[]; ran=[];
a1=log(log(90)); a2=log(log(2000)); da=log(log(93))-a1;
alt=round(a1/da):a2/da;
la=round(log(log(a))/da);
for j=alt
 i=find(la==j);
 if ~isempty(i)
  al=[al;mean(a(i))];
  ran=[ran;mean(r(i))];
  z1=NaN; ne=NaN; tr=NaN; dop=NaN;
  if pt>100e3
   rr=mean(real(sacf(:,i)),2)';
   ri=mean(imag(sacf(:,i)),2)';
   if rr(1)>0
    zm=find(rr<0);
    z2=nlags;
    z1=lag(end); tr=1; zm1=nlags;
    ne=rr(1);
    if ~isempty(zm)
     zm1=zm(1); g=rr([zm1-1 zm1]).*[1 -1];
     z1=sum(g.*lag([zm1 zm1-1]))/sum(g);
     z2=min([2*zm1-1 nlags]);
     gg=max([1+2.17*min(rr(zm1:z2))/ne 0]);
     tr=max([(1-sqrt(gg))/.23 .5]);
    end
    rr(zm)=-rr(zm); ri(zm)=-ri(zm);
    dop=sum(atan2(ri(2:z2),rr(2:z2)))/sum(lag(2:z2))/(2*pi);
   end
  end
  qf=[qf;[ne tr dop z1]];
 end
end

mi=23.5-7.5*tanh((al-200)/20);
f0r=[930*cos(.2) 930*cos(.4) 930 224 500 500 450]*1e6;
f0=f0r(site); c=3e8;
const=radcon(site)*ran.^2/pt/tp*diff(lag(1:2));

ti=mi.*(.38+1../(qf(:,2)+.4)*3.23e5./(qf(:,4)*f0)).^2;
ti(find(ti<150))=150;
ti(find(ti>3000))=3000;
te=ti.*qf(:,2);
ne=const.*qf(:,1).*(1+qf(:,2));
a21=7.52e5*(f0/c)^2*te./ne+1;
ne=const.*qf(:,1).*a21.*(a21+qf(:,2));
v=-qf(:,3)*c/2/f0;
v(find(v<-1000))=-1000;
v(find(v>1000))=1000;

if site<3
 h=[te ti v]; return
end
par=[ne/1e6 te ti v];
par(isnan(par))=0;

updateplot(fig,ax,al,.43*asinh(par/2))
set(get(ax,'xlabel'),'string','Altitude (km)')
set(get(ax,'ylabel'),'string','Log([cm^{-3} K K ms^{-1}])')
h=get(ax,'title');
set(ax,'visible','on')
