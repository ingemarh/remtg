function [def_file,chpar]=find_chpar(chpar)
global d_ExpInfo site
expdir='/kst/exp/'; defile='/rtg_def'; def_file=[];
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
 if ~isstr(chpar)
  chpar=d_ExpInfo;
  [i,chpar]=strtok(d_ExpInfo); chpar=strtok(chpar); %chpar=strtok(chpar,'_'); 
  while ~isempty(chpar) & ~exist([expdir chpar defile '.m']) & ~exist(['rtg_' chpar])
   chpar=chpar(1:end-1);
  end
 end
 if isempty(chpar) & isunix
  chpar=d_ExpInfo;
  [i,chpar]=strtok(d_ExpInfo); chpar=strtok(chpar);
  [i,j]=unix(['ls ' expdir '??/' chpar defile '.m']);
  while ~isempty(chpar) & i
   chpar=chpar(1:end-1);
   [i,j]=unix(['ls ' expdir '??/' chpar defile '.m']);
  end
 end
end
if isstr(chpar)
 if exist([expdir chpar defile '.m'])
  def_file=([expdir chpar defile]);
 elseif exist(['rtg_' chpar])
  def_file=which(['rtg_' chpar]);
 elseif isunix
  [i,def_file]=unix(['ls ' expdir '??/' chpar defile '.m']);
  def_file=def_file(1:end-1);
 end
end
