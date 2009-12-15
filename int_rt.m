function [i,filename,nbytes,err]=int_rt
global odate d dd_data butts bval rtdir d_ExpInfo d_parbl d_raw satch sitecode
%d=[]; fn=[];
if ~exist('odate','var'), odate=[]; end
dd_data=0; acc_parbl=0; err=0; d_ExpInfo='Unknown exp'; d_parbl=[]; nbytes=0; obytes=0; i=0;
while i<bval(2)
 i=i+1;
 if isempty(rtdir)
  rdir='/kst/exp/';
  s=1; j=1;
  while s
   filename=[rdir 'latest@' lower(char(sitecode.short(2+bval(4)))) '.mat'];
   jj=9;
   while ~exist(filename,'file')
    jj=jj-1, 
    if jj>0
     pause(1)
    else
     web(sprintf('http://www.eiscat.com/rtg/rtg.cgi?%s',sitecode.mini(bval(4))))
     disp('No data!'), err=1; i=i-1; odate=[]; return
    end
   end
   while s
    if rem(j,10)==0 & j>90
     beep
     disp('End of data?')
    elseif j>180 & (bval(4)~=6 | j>9000)
     disp('End of data!'), err=1; i=i-1; odate=[]; return
    end
    if bval(1)==0 | i>bval(2), return, end
    [s,fname]=unix(['ls -l ' filename]); j=j+1; pause(1)
    s=s+strcmp(fname,odate);
   end
   filename=fliplr(strtok(fliplr(fname)));
   s=2-exist(filename,'file');
  end
  odate=fname;
  [s,df]=unix(['ls -l ' filename]);
  for j=1:5, [nbytes,df]=strtok(df); end
  if s | isempty(nbytes)
   disp('End of data!'), err=1; i=i-1; odate=[]; return
  end
  nbytes=str2num(nbytes);
 else
  ext='*.mat'; if isunix, ext=[ext '*']; end
  if ~strcmp(odate,rtdir)
   d=dir(fullfile(rtdir,ext));
   if isempty(d)
    disp('No data!'), err=1; i=i-1; odate=[]; return
   end
  end
  if isempty(d)
   if rtdir(end)==filesep, rtdir(end)=[]; end
   [j,s]=fileparts(rtdir); df='%04d%02d%02d_%02d'; s=sscanf(s,df,4);
   if length(s)==4
    s=datevec(datenum([s' 0 0])+1.01/24);
    s=fullfile(j,sprintf(df,s(1:4)));
    if exist(s,'dir')
     d=dir(fullfile(s,ext));
     if ~isempty(d)
      rtdir=s;
     end
    end
   end
   if isempty(d)
    disp('End of data!'), err=1; i=i-1; odate=[]; filename=[]; return
   end
  end
  filename=fullfile(rtdir,d(1).name);
  nbytes=d(1).bytes; d(1)=[]; odate=rtdir;
 end
 if obytes & nbytes~=obytes
  j=j-1; odate=[]; return
 end
 d_raw=[];
 if strfind(filename,'.mat.bz2')
  tfile=[tempname '.mat'];
  unix(sprintf('bunzip2 -c %s >%s',filename,tfile));
  load(tfile), delete(tfile)
 else
  obytes=nbytes;
  load(filename)
 end
 if length(d_parbl)==128
  d_parbl=nd2eros4(d_parbl,d_data);
 end
 dd_data=dd_data+d_data;
 d_parbl=d_parbl(:).';
 acc_parbl=acc_parbl+d_parbl([7 8]);
 if bval(2)>30
  setbval(min([30 round(bval(2)/d_parbl(7))]),2)
  setbval(log(bval(2)),3)
 end
 d_parbl(7)=acc_parbl(1);
 d_parbl(8)=acc_parbl(2)/i;
 if ~isempty(butts) & ishandle(butts(1))
  setbval
  if bval(1)==0, return, end
 end
 if isempty(rtdir) & i<bval(2)
  fprintf('\r %d/%d PIs done ',i,bval(2))
 end
 pause(.1)
end
