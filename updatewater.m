function updatewater(fig,a,x,y,z)
global bval
j=findobj(a,'type','patch');
if length(j)==1 && sum(size(get(j,'zdata')))-sum(size(z))==5
 z0=zeros(size(z,1),1);
 c0=(max(max(z))+min(min(z)))/2*ones(size(z,1),2);
 set(j,'zdata',[z0 z(:,1) z z(:,end) z0 z0]','cdata',[c0 z c0 repmat(NaN,size(z,1),1)]','ydata',ones(size(z,2)+5,1)*y)
 if bval(8)~=3, set(a,'zlimmode','auto'), end
 if bval(8)==1, set(a,'xlim',[min(x) max(x)],'ylim',[min(y) max(y)]), end
 caxis(a,'auto');
else
 setcurrent(fig,a)
 waterfall(x,y,z);
 zoom(fig,'on')
 set(a,'xlim',[min(x) max(x)],'ylim',[min(y) max(y)],'view',[-10 50])
 set(get(a,'title'),'verticalalignment','middle')
end
set(a,'visible','on')