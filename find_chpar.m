function [def_file,chpar]=find_chpar(chpar)
global d_ExpInfo site
expdir='/kst/exp/'; defile='/rtg_def'; def_file=[];
if site==5 | site==6
 expdir='/kst/eros4/exp/';
 ff1=find(d_ExpInfo==' ');
 versionn=d_ExpInfo(ff1(end)+1:end);
 versionn(find(versionn=='.'))='_';
 defile=[defile '_' versionn];
end
if isempty(chpar)
 chpar=d_ExpInfo(find(d_ExpInfo~='-')); i=chpar;
 while ~isempty(chpar) & ~exist(['rtg_' chpar])
  [chpar,i]=strtok(i);
 end
 if ~isstr(chpar)
  chpar=d_ExpInfo; i=chpar;
  while ~isempty(chpar) & ~exist([expdir chpar defile '.m'])
   [chpar,i]=strtok(i);
  end
 end
end
if isstr(chpar)
 if exist(['rtg_' chpar])
  def_file=which(['rtg_' chpar]);
 elseif exist([expdir chpar defile '.m'])
  def_file=([expdir chpar defile]);
 end
end
