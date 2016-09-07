function rtgbuttons(fig)
global butts bval sitecode local
if nargin>0, getaxes(fig,0,0);, end
butts(1)=uicontrol('Style','togglebutton','string','GO','position',[0 0 40 30],'value',bval(1),'callback','setbval','fontsize',14);
butts(2)=uicontrol('Style','text','position',[120 0 20 20],'string',num2str(bval(2)),'value',bval(2));
butts(3)=uicontrol('Style','slider','position',[40 0 80 20],'min',0,'max',log(30),'sliderstep',[.2 1],'value',log(bval(2)),'tooltipstring','Post integration','callback','pitext');
butts(4)=uicontrol('Style','popupmenu','string',sitecode.short,'position',[145 0 55 20],'callback','datasel','tooltipstring','Data source','value',bval(4)+2);
butts(5)=uicontrol('Style','togglebutton','string','www','position',[390 0 35 20],'value',bval(5),'callback','setbval','tooltipstring','Web publish');
butts(6)=uicontrol('Style','popupmenu','string','1x1|2x1|3x1|2x2','position',[200 0 70 20],'value',bval(6),'callback','setbval','tooltipstring','Raw plots');
butts(7)=uicontrol('Style','togglebutton','string','ACF','position',[200 0 35 20],'value',bval(7),'callback','setbval','tooltipstring','Show ACFs','visible','off');
butts(8)=uicontrol('Style','popupmenu','string','No|Ran|All','position',[270 0 50 20],'value',bval(8),'callback','setbval','tooltipstring','Hold none|range|range&amplitude');
butts(9)=uicontrol('Style','togglebutton','string','B/W','position',[320 0 35 20],'value',bval(9),'callback','myb([],2)','tooltipstring','Grayscale');
butts(10)=uicontrol('Style','togglebutton','string','Tdev','position',[355 0 35 20],'value',bval(10),'callback','setbval','tooltipstring','Lineplots vs time');
butts(11)=uicontrol('Style','togglebutton','string','Phys','position',[235 0 35 20],'value',bval(11),'callback','setbval','tooltipstring','Physical parameters (prel)','visible','off');
uicontrol('Style','pushbutton','string','Quit','position',[505 0 35 25],'value',0,'callback','quit');
uicontrol('Style','pushbutton','string','Def','position',[0 35 35 20],'value',0,'tooltipstring','Force definition file','callback','[o,p]=uigetfile(''*.m'',''RTG definition file'');if o,if ~exist(''def_file''),global def_file,end,def_file=fullfile(p,o);end');
uicontrol('Style','pushbutton','string','Sel','position',[0 55 35 20],'value',0,'tooltipstring','Select plot for special threatment','callback','axessel(0)');
if local.ver>=7.5
 uicontrol('Style','pushbutton','string','Print','position',[0 75 30 20],'value',0,'tooltipstring','Select plot for printing','callback','axessel(1)');
end
uicontrol('Style','pushbutton','string','?','position',[425 0 20 20],'value',0,'tooltipstring','Help','callback','[o,p]=imread(which(''help.png''));figure(9),set(gcf,''position'',[10 40 820 310]),image(o),colormap(p),set(gca,''units'',''pixels'',''position'',[1 1 812 308],''ticklength'',[0 0])');
