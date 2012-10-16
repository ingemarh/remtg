function updateimage(fig,a,x,y,z)
global bval
j=findobj(a,'type','image');
z=asinh(z/2); % almost log
if length(j)==1 & isempty(find(size(get(j,'cdata'))-size(z)))
 if bval(8)==3
  set(a,'climmode','manual')
  zlim=get(j,'userdata');
 else
  zlim=smart_caxis(z,0.01);
  set(a,'climmode','auto')
 end
 z=(z-zlim(1))/diff(zlim);
 set(j,'cdata',z,'xdata',x,'ydata',y)
 if bval(8)==1
  set(a,'xlim',[min(x) max(x)],'ylim',[min(y) max(y)])
 end
else
 zlim=smart_caxis(z,0.01);
 z=(z-zlim(1))/diff(zlim);
 setcurrent(fig,a)
 j=imagesc(x,y,z);
 zoom(fig,'on')
 set(a,'ydir','normal')
 set(get(a,'title'),'verticalalignment','middle')
end
set(j,'userdata',zlim,'alphadata',double(~isnan(z)))
set(a,'visible','on')
end

function zlim=smart_caxis(z,a)
zok=z(find(isfinite(z)));
zs=sort(z(zok));
n=ceil(a*length(zs));
zlim=[zs(n+1) zs(end-n)];
end
