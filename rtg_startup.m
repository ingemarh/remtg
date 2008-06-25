set(0,'defaultAxesxMinorTick','on')
set(0,'defaultAxesyMinorTick','on')
set(0,'defaultFigureNumberTitle','off')
set(0,'defaultFigureSelectionHighlight','off')
set(0,'defaultFigureMenuBar','none')
set(0,'defaultFigureToolBar','figure')
set(0,'defaultUicontrolFontSize',10)
set(0,'defaultAxesFontSize',12)
set(0,'defaultTextFontSize',12)
set(0,'defaultAxesColorOrder',[1 0 0;0 1 0;0 0 1;0 0 0;1 0 1;0 1 1;1 1 0;.5 .5 .5])
set(0,'defaultFigurePaperType','A4')
set(0,'defaultFigurePaperUnits','centimeters')
set(0,'defaultAxesColor','none')
set(0,'defaultFigureRenderer','painters')
format compact
format short g
myb(128)
global local
matver=ver('matlab'); matver=matver.Version;
d=strfind(matver,'.'); matver(d(2:end))=[];
local.ver=str2num(matver);
clear matver d
local.x=prod(get(0,'ScreenSize'))-1;
if ~usejava('jvm') & local.ver>=7.5
 set(0,'DefaultAxesButtonDownFcn','zoom')
end
