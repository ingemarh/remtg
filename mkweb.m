function mkweb(sms)
global site lastweb bval figs local sitecode
if bval(4)>0 && exist('lastweb','var') && now-lastweb<30/86400, return, end
if local.x
 jpg='png'; flag='-r72';
else
 jpg='png256'; flag='-painters';
end
sitex=lower(sitecode.mini(site));
dir=tempdir;
files=[dir sitex '.html'];
fid=fopen(files,'w');
fprintf(fid,'<head>\n<TITLE>EISCAT-%s Real Time Graph</TITLE>\n</head>\n',char(sitecode.web(site)));
%figs=sort(get(0,'children'));
reloadfix=fix(10000*rand(1));
for i=sort(figs)
 ffig=[sitex num2str(i)];
 fname=[dir ffig];
 d=get(i,'UserData');
 if ~isempty(d)
  try
   if any(get(i,'PaperPosition')-d)
    set(i,'PaperPosition',d,'PaperOrientation','portrait')
   end
   if strcmp(local.name,'Octave')
    print(i,['-d' jpg],flag,fname)
   else
    print(i,['-d' jpg],'-noui',flag,fname)
   end
   files=[files ' ' fname '.png'];
   fprintf(fid,'<IMG SRC="%s?%d" ALT="%s"><P>\n',[ffig '.png'],reloadfix,get(i,'name'));
  catch
   disp(lasterr)
  end
 end
end
fclose(fid);
fname=[dir sitex 'sms.txt'];
fid=fopen(fname,'w');
fprintf(fid,'%s',sms);
fclose(fid);
files=[files ' ' fname];
if local.x
 heads=findobj(findobj(figs,'type','axes','tag','suptitle'),'type','text');
 set(heads,'visible','off'), set(heads,'visible','on')
else
 close all
end
if bval(5)==2
 files
 sitecode
 return
end
if site==6
 [i,d]=unix('ps | grep cp | grep -v grep');
 if i
  unix(['cp ' files ' /net/aurora/www/ht/rtg/']);
 end
end
[i,d]=unix('ps | grep curl | grep -v grep');
if i
 file=[];
 while ~isempty(files)
  [i,files]=strtok(files);
  file=[file ' -F file=@' i];
 end
 [status,cmdout]=unix(['curl -s ' file ' http://www.eiscat.se/raw/rtg/upload.cgi']);
end
lastweb=now;
