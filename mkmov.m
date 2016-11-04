function odir=mkmov(pldirs,ndumps)
if ~isempty(pldirs) && ~unix('which ffmpeg') && unix('ffmpeg -v error -buildconf | grep libx264')
 np=length(pldirs);
 rate=1; if ndumps<30, rate=3; end
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
   [dum1,dum2]=unix(sprintf('ffmpeg -r %d -i %s/%%08d.png -v error -vcodec libx264 -y -an %s/%s.mp4',rate,odir,odir,name));
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
