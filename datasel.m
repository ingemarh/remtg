function datasel
global rtdir bval butts d odate maxant
v=get(butts(4),'value');
if v==maxant
 dir=rtdir;
 if ~exist(dir,'dir'), dir='/data'; end
 if ~exist(dir,'dir'), dir='/data1'; end
 if ~exist(dir,'dir'), dir='.'; end
 [startfile,dir]=uigetfile([dir '/*.mat'],'Pick a start file in directory');
 if ~isequal(startfile,0) & ~isequal(dir,0)
  rtdir=dir;
  [s,d]=unix(['ls -1 ' dir '/[0-9]*.mat']); odate=rtdir;
  if s==0
   [filename,d1]=strtok(d,10);
   while ~isempty(filename) & isempty(strfind(filename,startfile))
    d=d1;
    [filename,d1]=strtok(d,10);
   end
  end
  set(butts(5),'visible','off','value',0)
  setbval(0,1)
 else
  set(butts(4),'value',bval(4))
 end
elseif v~=bval(4)
 if v<maxant
  rtdir=[];
  set(butts(5),'visible','on')
 else
  rtdir='Old data';
  set(butts(5),'visible','off','value',0)
 end
 setbval(0,1)
end
