function chpar=find_chpar(filename)
global d_ExpInfo site old_ExpInfo def_file old_chpar h5 local
if strcmp(d_ExpInfo,old_ExpInfo) && ~isempty(def_file)
 chpar=old_chpar; clear(def_file), return
end
expdir=fullfile(filesep,'kst','exp');
[i,chpar]=strtok(d_ExpInfo);
if isempty(chpar), chpar=i; end
chpar=strtok(chpar);
if isempty(old_ExpInfo) && ~isempty(def_file), return, end
defile='rtg_def'; dm=[defile '.m']; def_file=[];
idir=fileparts(filename);
infodir=[]; idir1=idir;
if ~isempty(h5)
 d=dir(fullfile(idir,['*' num2str(h5(7)) '.tar.gz']));
 if ~isempty(d)
  filenames=untar(fullfile(idir,d.name),local.tfile);
  if strcmp(local.name,'Octave')
   d=find(~cellfun(@isempty,strfind(filenames,dm))); %Octave contains
   idir=fullfile(local.tfile,fileparts(fileparts(fileparts(char(filenames(d))))));
  else
   d=find(contains(filenames,dm));
   idir=fileparts(fileparts(fileparts(char(filenames(d)))));
  end
  if isempty(d)
   idir=fileparts(idir);
   [i,sdir,sext]=fileparts(idir);
   idir1=[idir '_information']; idir=fullfile(idir,[sdir sext '_information']);
  end
  infodir=dir(idir);
 end
else
 idir=fileparts(idir);
 [i,sdir,sext]=fileparts(idir);
 idir1=[idir '_information']; idir=fullfile(idir,[sdir sext '_information']);
 infodir=dir(idir);
end
if isempty(infodir)
 idir=idir1; infodir=dir(idir);
end
while ~isempty(infodir) && isempty(def_file) && infodir(end).isdir
 infodir=fullfile(idir,infodir(end).name);
 idir1=dir(infodir);
 if idir1(end).isdir
  infodir=fullfile(infodir,idir1(end).name);
 end 
 if exist(fullfile(infodir,dm))
  def_file=fullfile(infodir,defile);
  chpar=strtok(chpar,'_');
 else
  idir=infodir; infodir=dir(idir); infodir(1:2)=[];
  for i=length(infodir):-1:1, if ~infodir(i).isdir, infodir(i)=[]; end, end
 end
end
while ~isempty(chpar) && isempty(def_file)
 if isunix && isempty(h5)
  [dum,inEI]=rtgix(['/bin/sh -c ''ls ' fullfile(expdir,'??',chpar,dm) ' 2>/dev/null''']);
 else
  dum=1;
 end
 if exist(fullfile(expdir,chpar,dm))
  def_file=fullfile(expdir,chpar,defile);
 elseif ~dum
  %def_file=strtok(ls(fullfile(expdir,'??',chpar,dm)));
  def_file=strtok(inEI);
  def_file=def_file(1:end-2);
 elseif exist(['rtg_' chpar])
  def_file=which(['rtg_' chpar]);
  def_file=def_file(1:end-2);
 else
  chpar(end)=[];
 end
end
if ~isempty(def_file)
 fprintf('RTG definition file set to: %s\n',def_file)
elseif ~strcmp(d_ExpInfo,old_ExpInfo)
 fprintf('No RTG definition file found\n',def_file)
end
old_ExpInfo=d_ExpInfo; old_chpar=chpar;
