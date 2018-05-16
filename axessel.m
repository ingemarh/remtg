function axessel(t)
if t==0
 disp('Press on the plot to threat specially, any other key disables')
else
 disp('Press on the figure for printing')
end
a=waitforbuttonpress;
if t==0
 global selax local
 if ~isempty(selax)
  set(selax.axes,'FontWeight','normal')
 end
 if a, clear selax, return, end
 selax.fig=gcf; selax.axes=gca;
 set(gca,'FontWeight','bold')
 [o,p]=uigetfile('*.m','Special threatment function');
 selax.fun=fullfile(p,o);
else
 printdlg(gcf)
end
