function rtgbuttons(fig)
global butts bval
if nargin>0, getaxes(fig,0,0);, end
butts(1)=uicontrol('Style','togglebutton','string','GO','position',[0 0 40 30],'value',bval(1),'callback','setbval','fontsize',14);
butts(2)=uicontrol('Style','text','position',[120 0 20 20],'string',num2str(bval(2)),'value',bval(2));
butts(3)=uicontrol('Style','slider','position',[40 0 80 20],'min',0,'max',log(30),'sliderstep',[1 .2],'value',log(bval(2)),'tooltipstring','Post integration','callback','pitext');
butts(4)=uicontrol('Style','popupmenu','string','Old|Disk|32m|42m|VHF|UHF|Kir|Sod|Zod|32p','position',[145 0 55 20],'callback','datasel','tooltipstring','Data source','value',bval(4)+2);
butts(5)=uicontrol('Style','togglebutton','string','www','position',[370 0 30 20],'value',bval(5),'callback','setbval','tooltipstring','Web publish');
butts(6)=uicontrol('Style','popupmenu','string','1x1|2x1|3x1|2x2','position',[200 0 60 20],'value',bval(6),'callback','setbval','tooltipstring','Raw plots');
butts(7)=uicontrol('Style','togglebutton','string','ACF','position',[200 0 30 20],'value',bval(7),'callback','setbval','tooltipstring','Show ACFs','visible','off');
butts(8)=uicontrol('Style','popupmenu','string','No|Ran|All','position',[260 0 50 20],'value',bval(8),'callback','setbval','tooltipstring','Hold none|range|range&amplitude');
butts(9)=uicontrol('Style','togglebutton','string','B/W','position',[310 0 30 20],'value',bval(9),'callback','myb([],2)','tooltipstring','Grayscale');
butts(10)=uicontrol('Style','togglebutton','string','Tdev','position',[340 0 30 20],'value',bval(10),'callback','setbval','tooltipstring','Lineplots vs time');
butts(11)=uicontrol('Style','togglebutton','string','Phys','position',[230 0 30 20],'value',bval(11),'callback','setbval','tooltipstring','Physical parameters (prel)','visible','off');
uicontrol('Style','pushbutton','string','Quit','position',[510 0 30 25],'value',0,'callback','quit');
