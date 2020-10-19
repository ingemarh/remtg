function axessel(t)
global figs
%if t==0
% disp('Press on the plot to threat specially, any other key disables')
%else
% disp('Press on the figure for printing')
%end
%a=waitforbuttonpress; Doesn't work anymore, so for now:
 for i=figs
  fprintf('%d: %s\n',i,get(i,'Name'))
 end
 set(0,'currentfigure',input('Select figure no: '))
if t==0
 global selax local
%if ~isempty(selax)
% set(selax.axes,'FontWeight','normal')
%end
%if a, clear selax, return, end
 selax.fig=gcf;
  ax=findobj(gcf,'type','axes','box','on');
  for i=1:length(ax) 
   fprintf('%d: %s (%g - %g)\n',i,get(get(ax(i),'Title'),'string'),get(ax(i),'xlim'))
  end
  i=input(sprintf('Select plot window (1-%d): ',length(ax)));
  selax.axes=ax(i);
%selax.axes=gca;
%set(gca,'FontWeight','bold')
 [o,p]=uigetfile('*.m','Special threatment function');
 selax.fun=fullfile(p,o);
else
 printdlg(gcf)
end
