function chpar=find_chpar(filename)
global d_ExpInfo site old_ExpInfo def_file old_chpar
if strcmp(d_ExpInfo,old_ExpInfo) & ~isempty(def_file)
 chpar=old_chpar; return
end
expdir=fullfile(filesep,'kst','exp');
defile='rtg_def'; dm=[defile '.m']; def_file=[];
[i,chpar]=strtok(d_ExpInfo); chpar=strtok(chpar);
idir=fileparts(fileparts(filename));
infodir=dir(fullfile(idir,'*_information'));
while ~isempty(infodir) & isempty(def_file) & infodir(end).isdir
 infodir=fullfile(idir,infodir(end).name);
 if exist(fullfile(infodir,dm))
  def_file=fullfile(infodir,defile);
 else
  idir=infodir; infodir=dir(idir); infodir(1:2)=[];
  for i=length(infodir):-1:1, if ~infodir(i).isdir, infodir(i)=[]; end, end
 end
end
while ~isempty(chpar) & isempty(def_file)
 [dum,inEI]=unix(['ls ' fullfile(expdir,'??',chpar,dm)]);
 if exist(fullfile(expdir,chpar,dm))
  def_file=fullfile(expdir,chpar,defile);
 elseif isempty(strfind(inEI,' '))
  def_file=ls(fullfile(expdir,'??',chpar,dm));
  def_file=def_file(1:end-3);
 elseif exist(['rtg_' chpar])
  def_file=which(['rtg_' chpar]);
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
