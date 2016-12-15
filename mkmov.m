function odir=mkmov(pldirs,ndumps)
if ~isempty(pldirs) && ~unix('which ffmpeg') && ~unix('ffmpeg -v error -buildconf | grep enable-libvpx')
 np=length(pldirs);
 rate=3; if ndumps<30, rate=10; end
 [dpath,name,ext]=fileparts(pldirs{1});
 odir=sprintf('%s_%s_%d',dpath,name,np);
 mkdir(odir);
 f=dir(pldirs{1});
 for fn=f'
  [path,name,ext]=fileparts(fn.name);
  if strcmp(ext,'.png') 
   for i=1:np
    movefile(fullfile(pldirs{i},fn.name),fullfile(odir,sprintf('%08d.png',i)));
   end
   [dum1,dum2]=unix(sprintf('ffmpeg -r %d -i %s/%%08d.png -v error -vcodec libvpx -qmax 50 -y -dn -an %s/%s.webm',rate,odir,odir,name));
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
 rmdir(dpath);
end
