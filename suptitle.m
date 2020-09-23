function hout=suptitle(str,fig)
%SUPTITLE Puts a title above all subplots.
%	SUPTITLE('text') adds text to the top of the figure
%	above all subplots (a "super title"). Use this function
%	after all subplot commands.

% Drea Thomas 6/15/95 drea@mathworks.com
global local
if nargin<2
 fig=gcf;
end

% Parameters used to position the supertitle.

% Amount of the figure window devoted to subplots
plotregion = .94;

% Y position of title in normalized coordinates
titleypos  = .96;

% Fontsize for supertitle
fs = get(fig,'defaultaxesfontsize')+2;

% Fudge factor to adjust y spacing between subplots
fudge=1;

figunits = get(fig,'units');

% Get the (approximate) difference between full height (plot + title
% + xlabel) and bounding rectangle.

	if (~strcmp(figunits,'pixels')),
		set(fig,'units','pixels');
		pos = get(fig,'position');
		set(fig,'units',figunits);
	else,
		pos = get(fig,'position');
	end
	ff = (fs-4)*1.27*5/pos(4)*fudge;

        % The 5 here reflects about 3 characters of height below
        % an axis and 2 above. 1.27 is pixels per point.

% Determine the bounding rectange for all the plots

h = findobj(fig,'Type','axes');  % Change suggested by Stacy J. Hills

max_y=0;
min_y=1;

oldtitle =[];
for i=1:length(h),
	if (~strcmp(get(h(i),'Tag'),'suptitle')),
		pos=get(h(i),'position');
		if (pos(2) < min_y), min_y=pos(2)-ff/5*3;end;
		if (pos(4)+pos(2) > max_y), max_y=pos(4)+pos(2)+ff/5*2;end;
	else,
		oldtitle = h(i);
	end
end

if max_y > plotregion,
	scale = (plotregion-min_y)/(max_y-min_y);
	for i=1:length(h),
		pos = get(h(i),'position');
		pos(2) = (pos(2)-min_y)*scale+min_y;
		pos(4) = pos(4)*scale-(1-scale)*ff/5*3;
		set(h(i),'position',pos);
	end
end

np = get(fig,'nextplot');
set(fig,'nextplot','add');
if ~isempty(oldtitle)
	delete(oldtitle);
end
if strcmp(local.name,'Octave')
 oax=gca;
 ha=axes('position',[0 1 1 1],'visible','off','Tag','suptitle');
 ht=text(.5,titleypos-1,str);set(ht,'horizontalalignment','center','fontsize',fs),
 axes(oax)
else
 ha=axes(fig,'position',[0 1 1 1],'visible','off','Tag','suptitle');
 ht=text(ha,.5,titleypos-1,str);set(ht,'horizontalalignment','center','fontsize',fs),
end
set(fig,'nextplot',np);
if nargout,
	hout=ht;
end
set(fig,'nextplot',np);
if nargout,
	hout=ht;
end
