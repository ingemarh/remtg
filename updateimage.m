function updateimage(fig,a,x,y,z)
global bval local
j=findobj(a,'type','image');
%if isempty(find(z<0))
% z=log(z);
%else
 z=asinh(z/2); % almost log
%end
if ~strcmp(local.name,'Octave') && length(j)==1 && isempty(find(size(get(j,'cdata'))-size(z)))
 if bval(8)==3
  zlim=get(j,'userdata');
 else
  zlim=smart_caxis(z,0.001);
 end
 z=(z-zlim(1))/diff(zlim);
 set(j,'cdata',z,'xdata',x,'ydata',y)
 if bval(8)==1
  set(a,'xlim',[min(x) max(x)],'ylim',[min(y) max(y)])
 end
else
 zlim=smart_caxis(z,0.001);
 z=(z-zlim(1))/diff(zlim);
 if strcmp(local.name,'Octave') && (local.ver<=3 || strcmp(graphics_toolkit,'gnuplot'))
  x=x([1 end]); y=y([1 end]);
  setcurrent(fig,a); j=imagesc(x,y,z);
 else
  j=imagesc(x,y,z,'parent',a),
 end
 if local.ver>3, zoom(fig,'on'), end
 set(a,'ydir','normal','clim',[0 1])
 set(get(a,'title'),'verticalalignment','middle')
end
set(j,'userdata',zlim,'alphadata',double(~isnan(z)))
set(a,'visible','on')
end

function zlim=smart_caxis(z,a)
zs=sort(z(find(isfinite(z))));
n=ceil(a*length(zs));
zlim=[zs(n+1) zs(end-n)];
end
