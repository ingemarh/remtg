function timedev(fig,ntim,thead,head)
global bval tdev tdim
sep=find(isnan(tdev))-1; np=length(sep);
np2=floor(sqrt(np));
ax=getaxes(fig,np/np2,np2,'Time development',head); s0=1;

x=0:(ntim-1);
tim=tdim.time(find(isfinite(tdim.time)));
if ~any(diff(round(86400*diff(tim)))) & length(tim)>1 & str2num(version('-release'))>12.1 & prod(get(0,'ScreenSize'))~=1
 td=mean(diff(tim)); x=tdim.time(1)+x*td;
end
for i=1:np
 if x(1)
  updateimage(fig,ax(i),fliplr(x),0:(sep(i)-s0),fliplr(tdim.data(s0:sep(i),:)))
  datetick(ax(i),'x',15,'keeplimits')
  set(ax(i),'xdir','normal')
 else
  updateimage(fig,ax(i),x,0:(sep(i)-s0),tdim.data(s0:sep(i),:))
  set(ax(i),'xdir','reverse','xtickmode','auto','xticklabelmode','auto')
 end
 s0=sep(i)+2;
 if i>length(thead)
  set(get(ax(i),'title'),'string',['Line plot ' num2str(i)])
 else
  set(get(ax(i),'title'),'string',char(thead(i)))
 end
end
if ~x(1)
 set(get(ax(np),'xlabel'),'string','Number PIs ago')
else
 set(get(ax(np),'xlabel'),'string','Time (UT)')
end
set(get(ax(1),'ylabel'),'string','Point #')
