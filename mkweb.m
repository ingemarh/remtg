function mkweb(sms)
global site lastweb bval figs
if bval(4)<8 & exist('lastweb','var') & now-lastweb<30/86400, return, end
jpg='png256'; flag=''; using_x=prod(get(0,'ScreenSize'));
if using_x>1, jpg='png'; flag='-r72'; end
sites='kstve2z'; sitex=sites(site);
dir=tempdir;
files=[dir sitex '.html'];
fid=fopen(files,'w');
wsite={'Kiruna','Sodankyl&auml;','Troms&oslash; UHF','Troms&oslash; VHF','ESR1','ESR2','Zod'};
fprintf(fid,'<head>\n<TITLE>EISCAT-%s Real Time Graph</TITLE>\n</head>\n',char(wsite(site)));
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
   print(i,['-d' jpg],'-noui',flag,fname)
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
if using_x>1
 heads=findobj(findobj(figs,'type','axes','tag','suptitle'),'type','text');
 set(heads,'visible','off'), set(heads,'visible','on')
else
 close all
end
[i,d]=unix('ps | grep curl | grep -v grep');
if i
 file=[];
 while ~isempty(files)
  [i,files]=strtok(files);
  file=[file ' -F file=@' i];
 end
 unix(['curl -s' file ' "http://www.eiscat.com/raw/rtg/upload.cgi" >/dev/null &']);
end
lastweb=now;
