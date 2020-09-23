function t1=raw(fig,name,head,xlim,amp)
if nargin>4
 global d_raw bval local
 rd=real(d_raw); id=imag(d_raw);
else
 global rd id bval local
end
i=[1 1;2 1;3 1;2 2];
lrd=length(rd); n=1;
if nargin<4
 a7=getaxes(fig,i(bval(6),1),i(bval(6),2),name,head);
 xlim=[0 lrd-1]; ndel=0;
else
 npanel=size(xlim,1); ndel=1;
 a7=getaxes(fig,i(npanel,1),i(npanel,2),name,head);
end
for i=a7'
 j=findobj(i,'type','line');
 if ~isempty(j) && size(get(j(1),'ydata'),2)==lrd
  set(j(1),'ydata',id)
  set(j(2),'ydata',rd)
  if bval(8)~=3, set(i,'ylimmode','auto'); end
  if bval(8)==1, set(i,'xlim',xlim(n,:)), end
 else
  x=0:(lrd-1);
  if local.ver>3
   plot(x,rd,x,id,'parent',i)
  else
   setcurrent(fig,i)
   plot(x,rd,x,id)
  end
  set(i,'xlim',xlim(n,:))
  set(get(i,'title'),'verticalalignment','baseline')
 end
 if local.ver>3, zoom(fig,'on'), end
 n=n+ndel;
end
t1=get(a7(1),'title');
