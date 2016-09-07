function odir=mkmov(pldirs)
if ~isempty(pldirs)
 np=length(pldirs);
 [path,name,ext]=fileparts(pldirs{1});
 odir=sprintf('%s_%s_%d',path,name,np);
 mkdir(odir);
 f=dir(pldirs{1});
 for fn=f'
  [path,name,ext]=fileparts(fn.name);
  if strcmp(ext,'.png') 
   for i=1:np
    movefile(fullfile(pldirs{i},fn.name),fullfile(odir,sprintf('%08d.png',i)));
   end
   [dum1,dum2]=unix(sprintf('ffmpeg -r 1 -i %s/%%08d.png -v error -vcodec libx264 -y -an %s/%s.mp4',odir,odir,name));
   for i=1:np
    delete(fullfile(odir,sprintf('%08d.png',i)));
   end
  elseif strcmp(ext,'.txt') || strcmp(ext,'.html') 
   for i=1:np
    delete(fullfile(pldirs{i},fn.name));
   end
  end
 end
 for i=1:np
  rmdir(pldirs{i});
 end
end
