function datasel
global rtdir bval butts d odate h5 local
v=get(butts(4),'value')-2;
if v==0
 if ~isempty(rtdir) && exist(rtdir,'dir'), ndir=rtdir;
 elseif exist(fullfile(filesep,'data'),'dir'), ndir=fullfile(filesep,'data');
 elseif exist(fullfile(filesep,'data1'),'dir'), ndir=fullfile(filesep,'data1');
 else, ndir=pwd; end
 %[startfile,ndir,dum]=uigetfile(fullfile(ndir,'*.mat*'),'Pick a start file in directory');
 if strcmp(getenv("EISCATSITE"),'Hub')
  [startfile,ndir,dum]=uigetfile(fullfile(ndir,'*.*'),'Pick a start file in directory');
 else
  [startfile,ndir,dum]=uigetfile({'*.mat*','Pick a start file in directory';'*hdf5','L1/2 hdf5 file'});
 end
 if ~isequal(startfile,0) && ~isequal(ndir,0)
  rtdir=ndir;
  d=dir(fullfile(rtdir,'*.mat*')); odate=rtdir;
  if isempty(d)
   h5data
  else
   h5=[];
   while ~isempty(d) && isempty(strfind(d(1).name,startfile))
    d(1)=[];
   end
  end
  set(butts(5),'visible','off','value',0)
  setbval(0,1)
 else
  set(butts(4),'value',bval(4)+2)
 end
elseif v~=bval(4)
 if v>0
  rtdir=[];
  set(butts(5),'visible','on')
 else
  rtdir='Old data';
  set(butts(5),'visible','off','value',0)
 end
 setbval(0,1)
end
