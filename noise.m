function [tsys,blev]=noise(fig,ax,nb,nc,back,cal,loopc)
global rd d_parbl
ncal=length(find(nb+nc)); tsys=[]; blev=[]; tcal=d_parbl(21);
if ncal==0
 set(ax,'visible','off'), return
end
tsys=[]; clev=[]; x=zeros(max(nb+nc)+1,1)*ones(1,ncal); y=x*NaN;
ble=[]; cle=[]; loopc=2*sqrt(loopc.*ones(1,ncal));
for i=1:ncal
 if nb(i)
  b=rd((back(i)+1):(back(i)+nb(i))); xx=1:nb(i);
  bl=median(b); blev=[blev bl]; ble=[ble sqrt(bl)/loopc(i)];
  x(xx,i)=xx'-1; y(xx,i)=real(sqrt(b))/loopc(i);
 end
 if nc(i)
  c=rd((cal(i)+1):(cal(i)+nc(i))); xx=1:nc(i);
  cl=median(c); clev=[clev cl]; cle=[cle sqrt(cl)/loopc(i)];
  x(nb(i)+1+xx,i)=xx'-1; y(nb(i)+1+xx,i)=real(sqrt(c))/loopc(i);
  if ~isempty(b)
   tsys=[tsys tcal/(cl/bl-1)];
  end
 end
end
updateplot(fig,ax,x,y)
yt=get(ax,'ytick');
btic=round([mean(ble) mean(cle)]);
[a,p1]=min(abs(yt-btic(1)));
[a,p2]=min(abs(yt-btic(2)));
yt(p1)=btic(1);
if p2~=p1, yt(p2)=btic(2); elseif btic(2)~=btic(1), yt=[yt(1:p1) btic(2) yt((p1+1):end)]; end
set(ax,'ytick',sort(yt));
tsys(find(tsys<0 | tsys>1000))=NaN;
h=get(ax,'title');
if length(tsys)>1
 set(h,'string',['Tsys=[' sprintf('%d ',round(tsys(1:(end-1)))) sprintf('%d]K (%gK)',round(tsys(end)),tcal)])
else
 set(h,'string',['Tsys=' sprintf('%d',round(tsys)) sprintf(' K (%gK)',tcal)])
end
h=get(ax,'ylabel');
set(h,'string','Amplitude')
