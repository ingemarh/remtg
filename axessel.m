function axessel
global selax
disp('Press on the plot to threat specially, any other key disables')
a=waitforbuttonpress;
if ~isempty(selax)
  set(selax.fig(2),'FontWeight','normal')
end
if a, clear selax, return, end
selax.fig=[gcf gca];
set(gca,'FontWeight','bold')
[o,p]=uigetfile('*.m','Special threatment function');
selax.fun=fullfile(p,o);
