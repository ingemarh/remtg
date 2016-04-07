function ax=getaxes(fig,s1,s2,name,head)
global figs local
if ~ishandle(fig)
 figure(fig)
 if local.x
  d=get(0,'defaultfigureposition');
  set(fig,'position',[d(1:2)+[1 -1]*fig d(3:4)])
 elseif local.ver==6.5
  close(fig),figure(fig); % Matlab R13 bug
 end
end
ax=sort(findobj(fig,'type','axes','tag',[]));
if strcmp(local.name,'Octave'), ax=flipud(ax); end
h=findobj(findobj(fig,'type','axes','tag','suptitle'),'type','text');
if nargin<4, name='EISCAT rtg'; end
if nargin<5, head='EISCAT rtg'; end
if isempty(ax) || length(ax)~=prod([s1 s2]) || isempty(h)
 delete(ax)
 ax=0;
 set(0,'currentfigure',fig)
 for i=1:prod([s1 s2])
  ax(i,1)=subplot(ceil(s1),s2,i);
  set(get(ax(i),'title'),'verticalalignment','middle')
 end
 h=suptitle(head); set(h,'interpreter','none')
 if s1==0, set(gca,'visible','off'), end
 s1=6*min([max([1 ceil(s1)]) 4])+4;
 pos=[0 14.8-s1/2 20 s1];
 set(fig,'PaperPosition',pos,'name',name,'UserData',pos)
elseif nargin>3
 set(h,'string',head)
 set(fig,'name',name)
end
if ~any(fig==figs), figs=[figs fig]; end
