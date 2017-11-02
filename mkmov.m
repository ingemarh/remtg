function odir=mkmov(pldirs,ndumps)
prog='ffmpeg';
if unix(['which ' prog]) || unix([prog ' -v error -buildconf | grep enable-libvpx']), prog='mencoder'; end
if unix(['which ' prog]), return, end
if ~isempty(pldirs)
 np=length(pldirs);
 rate=3; if ndumps<30, rate=10; end
 [dpath,name,ext]=fileparts(pldirs{1});
 odir=sprintf('%s_%s_%d',dpath,name,np);
 mkdir(odir);
 f=dir(pldirs{1});
 for fn=f'
  [path,name,ext]=fileparts(fn.name);
  if strcmp(ext,'.png')
   if strcmp(prog,'ffmpeg')
    [dum1,dum2]=unix(sprintf('%s -r %d -pattern_type glob -i ''%s/*/%s.png'' -v error -vcodec libvpx -qmax 50 -y -dn -an %s/%s.webm',prog,rate,dpath,name,odir,name));
   else
    d=pwd; cd(dpath); unix(sprintf('ls */%s.png > list.txt',name));
    [dum1,dum2]=unix(sprintf('mencoder mf://@list.txt -mf fps=%d:type=png -ovc copy -oac copy -o %s/%s.avi',rate,odir,name));
    delete('list.txt'); cd(d)
   end
   for i=1:np
    delete(fullfile(pldirs{i},fn.name));
   end
  elseif strcmp(ext,'.txt') || strcmp(ext,'.html') 
   for i=1:np
    delete(fullfile(pldirs{i},fn.name));
   end
  end
 end
 %for i=1:np
 % rmdir(pldirs{i});
 %end
 rmdir(dpath,'s');
end
