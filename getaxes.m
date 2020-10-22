function ax=getaxes(fig,s1,s2,name,head)
global figs local selax
if ~isgraphics(fig)
 figg=figure(fig);
 if local.x
  d=get(0,'defaultfigureposition');
  set(figg,'position',[d(1:2)+[1 -1]*fig d(3:4)])
 elseif local.ver==6.5
  close(figg),figg=figure(fig); % Matlab R13 bug
 end
 fig=figg;
elseif ~strcmp(local.name,'Octave')
 fig=findobj(0,'Number',fig);
end
if ~isempty(selax) && isfield(selax,'wtg')
 if ischar(selax.wtg)
  [selax.fig,selax.sp,fun]=strread(selax.wtg,'%d,%d,%s');
  selax.fun=fun{1};
 else
  selax.fig=selax.wtg{1}; selax.sp=selax.wtg{2}; selax.fun=selax.wtg{3};
 end
 selax=rmfield(selax,'wtg');
end
ax=flipud(findobj(fig,'type','axes','tag',''));
h=findobj(fig,'type','axes','tag','suptitle');
if ~isempty(h), h=findobj(h,'type','text'); end
if nargin<4, name='EISCAT rtg'; end
if nargin<5, head='EISCAT rtg'; end
if isempty(ax) || length(ax)~=prod([s1 s2]) || isempty(h)
 ax=0;
 set(0,'currentfigure',fig)
 for i=1:prod([s1 s2])
  ax(i,1)=subplot(ceil(s1),s2,i);
  set(get(ax(i),'title'),'verticalalignment','baseline')
 end
 if isfield(selax,'sp') && fig==selax.fig
  selax.axes=ax(selax.sp);
  selax=rmfield(selax,'sp');
 end
 if local.ver>3
  h=suptitle(head,fig); set(h,'interpreter','none')
  if strcmp(local.name,'Octave') && strcmp(graphics_toolkit,'gnuplot')
   set(h,'position',get(h,'position')-[0 300 0])
  end
  if s1==0, set(gca,'visible','off'), end
  s1=6*min([max([1 ceil(s1)]) 4])+4;
  pos=[0 14.8-s1/2 20 s1];
  set(fig,'PaperPosition',pos,'name',name,'UserData',pos)
 end
elseif nargin>3
 set(h,'string',head)
 set(fig,'name',name)
end
if ~isnumeric(fig), fig=get(fig,'Number'); end
if ~any(fig==figs), figs=[figs fig]; end
