function updateplot(fig,a,x1,y1,x2,y2)
global bval tdev selax local
narg=nargin;
if ~isempty(selax) && selax.fig==fig && selax.axes==a
 %stack=dbstack
 %if ~strcmp(stack(2).name,'spitspec')
  selax.x1=x1; selax.y1=y1;
  if nargin>4
   selax.x2=x2; selax.y2=y2;
  end
 %end
end
if rem(narg,2)==1
  mktd=0; narg=narg-1;
else
  mktd=1;
end
np=(narg-2)/2;
if narg<5, np=prod(size(y1))/length(x1); end 
j=findobj(a,'type','line');
if length(j)==np && length(get(j(end),'ydata'))==size(y1,1)
 if narg==6 || np==1
  set(j(np),'ydata',y1,'xdata',x1)
  if np>1, set(j(1),'ydata',y2,'xdata',x2), end
 else
  for i=1:np
   if length(x1(:))==length(y1(:))
    set(j(np-i+1),'ydata',y1(:,i),'xdata',x1(:,i))
   else
    set(j(np-i+1),'ydata',y1(:,i),'xdata',x1)
   end
  end
 end
 if bval(8)~=3, set(a,'ylimmode','auto'), end
 if bval(8)==1, set(a,'xlim',[min(min(x1)) max(max(x1))]), end
else
 if local.ver>3
  if narg==6
   plot(x1,y1,x2,y2,'parent',a)
   x1=[x1(:);x2(:)];
  else
   plot(x1,y1,'parent',a)
  end
  zoom(fig,'on')
 else
  setcurrent(fig,a)
  if narg==6
   plot(x1,y1,x2,y2)
   x1=[x1(:);x2(:)];
  else
   plot(x1,y1)
  end
 end
 set(a,'xlim',[min(min(x1)) max(max(x1))])
 set(get(a,'title'),'verticalalignment','baseline')
end
set(a,'visible','on')
if mktd
 tdev=[tdev;y1(find(isfinite(y1)));NaN];
end
