function mkweb(sms)
global site lastweb bval figs local sitecode pldirs
if bval(4)>0 && ~isempty(lastweb) && now-lastweb<30/86400, return, end
if local.x
 jpg='png'; flag='-r72';
else
 jpg='png256'; flag='-painters';
end
sitex=lower(sitecode.mini(site));
dir=local.tempdir;
files=fullfile(dir,[sitex '.html']);
fid=fopen(files,'w');
fprintf(fid,'<head>\n<TITLE>EISCAT-%s Real Time Graph</TITLE>\n</head>\n',char(sitecode.web(site)));
reloadfix=fix(10000*rand(1));
for i=sort(figs)
 ffig=[sitex num2str(i)];
 fname=fullfile(dir,ffig);
 if local.ver>3, d=get(i,'UserData');
 else, d=0; end
 if ~isempty(d)
  try
   if local.ver>3
    if any(get(i,'PaperPosition')-d)
     set(i,'PaperPosition',d,'PaperOrientation','portrait')
    end
    if strcmp(local.name,'Octave')
     print(i,'-dpng','-r72',fname)
    else
     print(i,['-d' jpg],'-noui',flag,fname)
    end
    files=[files ' ' fname '.png'];
    fprintf(fid,'<IMG SRC="%s?%d" ALT="%s"><P>\n',[ffig '.png'],reloadfix,get(i,'name'));
   else
    set(0,'currentfigure',i)
    fname=[fname '.png'];
    print(fname,'-dpng')
    files=[files ' ' fname];
    fprintf(fid,'<IMG SRC="%s?%d"><P>\n',[ffig '.png'],reloadfix);
   end
  catch
   disp(lasterr)
  end
 end
end
fclose(fid);
fname=fullfile(dir,[sitex 'sms.txt']);
fid=fopen(fname,'w');
fprintf(fid,'%s',sms);
fclose(fid);
files=[files ' ' fname];
if bval(5)==3
 if bval(4)==0
  global d_ExpInfo d_parbl
  [dum,d]=strtok(d_ExpInfo); d=[dir strtok(d)];
  if ~exist(d), mkdir(d); end
  d=fullfile(d,sprintf('%d%02d%02d_%02d%02d%02.0f_%g',d_parbl(1:7))); mkdir(d);
  pldirs{end+1}=d;
  dum=unix(['mv ' files ' ' d]);
 end
 return
end
if strcmp(local.name,'Octave')
elseif local.x
 heads=findobj(findobj(figs,'type','axes','tag','suptitle'),'type','text');
 set(heads,'visible','off'), set(heads,'visible','on')
else
 close all
end

if site==6
 [i,d]=unix('ps | grep cp | grep -v grep');
 if i
  unix(['cp ' files ' /net/aurora/www/ht/rtg/']);
 end
end
if site==4 || site==3
 unix(['scp -q ' files ' palver5:/var/www/html/rtg/']); 
end
% RTG upload to www.eiscat.se
[i,d]=unix('ps | grep curl | grep -v grep');
if i
 file='';
 while ~isempty(files)
  [i,files]=strtok(files);
  file=[file ' -F file=@' i];
 end
 [status,cmdout]=unix(['curl -s ' file ' http://portal.eiscat.se/raw/rtg/upload.cgi']);
end
lastweb=now;
