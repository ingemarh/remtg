function timedev(fig,ntim,thead,head)
global bval tdev tdim
sep=find(isnan(tdev))-1; np=length(sep);
np2=floor(sqrt(np));
ax=getaxes(fig,np/np2,np2,'Time development',head); s0=1;
for i=1:np
 updateimage(fig,ax(i),0:(ntim-1),0:(sep(i)-s0),tdim(s0:sep(i),:))
 set(ax(i),'xdir','reverse')
 s0=sep(i)+2;
 if i>length(thead)
  set(get(ax(i),'title'),'string',['Line plot ' num2str(i)])
 else
  set(get(ax(i),'title'),'string',char(thead(i)))
 end
end
set(get(ax(np),'xlabel'),'string','Number PIs ago')
set(get(ax(1),'ylabel'),'string','Point #')
