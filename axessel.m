function axessel(t)
if t==0
 disp('Press on the plot to threat specially, any other key disables')
else
 disp('Press on the figure for printing')
end
a=waitforbuttonpress;
if t==0
 global selax
 if ~isempty(selax)
  set(selax.fig(2),'FontWeight','normal')
 end
 if a, clear selax, return, end
 selax.fig=[gcf gca];
 set(gca,'FontWeight','bold')
 [o,p]=uigetfile('*.m','Special threatment function');
 selax.fun=fullfile(p,o);
else
 printdlg(gcf)
end
