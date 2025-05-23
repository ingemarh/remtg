format compact
format short g
addpath(fileparts(mfilename('fullpath')))
myb(128)
fprintf('EISCAT Real Time Graph vs %.1f\n',3.2)
global local
try
 matvers=ver('MATLAB');
 if isempty(matvers), matvers=ver; end
 matver=matvers.Version;
 d=strfind(matver,'.'); matver(d(2:end))=[];
 [matver,d]=strtok(matver,'.');
 local.ver=str2num(d(2:end))/10;
 if local.ver>=1, local.ver=0.9+local.ver/100; end
 local.ver=local.ver+str2num(matver);
 local.name=matvers(1).Name;
 TMP=getenv('TMP');
catch
 local.ver=3; local.name='Octave'; local.x=0;
 set(0,'defaultTextFontName','dejavu')
 TMP=getenv('TMPDIR');
end
local.userdir=pwd;
if ~isfield(local,'tempdir')
 if ispc || ~isempty(TMP)
  local.tempdir=tempdir;
  local.userdir=userpath;
 else
  local.tempdir=fullfile(getenv('HOME'),'tmp');
 end
 clear TMP
end
if ~exist(local.tempdir,'dir'), mkdir(local.tempdir); end
local.tfile=tempname(local.tempdir);
if strcmp(local.name,'Octave') || local.ver<8.4
 groot=0;
 confirm_recursive_rmdir(0)
 warning('off','image: non-linear X, Y data is ignored')
 warning('off','all')
else
 set(groot,'defaultAxesTitleFontSizeMultiplier',1)
 set(groot,'defaultAxesLabelFontSizeMultiplier',1)
 set(groot,'defaultAxesTitleFontWeight','normal')
end
if local.ver>3.4
 set(groot,'defaultAxesFontSize',12)
 set(groot,'defaultFigureVisible','on')
 set(groot,'defaultFigureMenuBar','none')
 set(groot,'defaultFigureNumberTitle','off')
 set(groot,'defaultFigurePaperType','A4')
 set(groot,'defaultFigurePaperUnits','centimeters')
 %set(groot,'defaultFigureRenderer','painters')
 set(groot,'defaultFigureSelectionHighlight','off')
 set(groot,'defaultFigureToolBar','figure')
 set(groot,'defaultUicontrolFontSize',10)
 set(groot,'defaultAxesxMinorTick','on')
 set(groot,'defaultAxesyMinorTick','on')
 set(groot,'defaultTextFontName','Helvetica')
 set(groot,'defaultAxesFontName','Helvetica')
 d=get(groot,'ScreenSize');
 local.x=prod(d)-1;
 if local.ver>=7.5 && ~usejava('jvm')
  set(groot,'DefaultAxesButtonDownFcn','zoom')
 end
end
set(groot,'defaultTextFontSize',12)
set(groot,'defaultAxesColorOrder',[1 0 0;0 1 0;0 0 1;0 0 0;1 0 1;0 1 1;1 1 0;.5 .5 .5])
set(groot,'defaultAxesColor','none')
if strcmp(local.name,'Octave')
 [~,d]=strtok(fliplr(which('rtg')),filesep);
 d=fullfile(fliplr(d),'private');
 if exist(d,'dir'), addpath(d), end
 warning('off','Octave:missing-glyph')
else
 warning('off','MATLAB:connector:connector:ConnectorNotRunning')
end
if local.x
 matver=get(groot,'defaultFigurePosition');
 set(groot,'defaultFigurePosition',[d(3)/2 matver(2:4)])
end
clear matver matvers d TMP
