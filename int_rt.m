function [i,filename,nbytes,err]=int_rt
global odate d dd_data butts bval rtdir d_ExpInfo d_parbl d_raw satch
%d=[]; fn=[];
if ~exist('odate','var'), odate=[]; end
dd_data=0; acc_parbl=0; err=0; d_ExpInfo=[]; d_parbl=[]; nbytes=0; obytes=0; i=0;
while i<bval(2)
 i=i+1;
 if isempty(rtdir)
  ext={'32m','42m','uhf','vhf','kir','sod','zod','32p'};
  rdir='/kst/exp/';
  s=1; j=1;
  while s
   filename=[rdir 'latest@' char(ext(bval(4))) '.mat'];
   if ~exist(filename,'file'), pause(.6)
    if ~exist(filename,'file')
     wsite='E2VUKS P';
     web(sprintf('http://www.eiscat.com/rtg/rtg.cgi?%s',wsite(bval(4))))
     disp('No data!'), err=1; i=i-1; odate=[]; return
    end
   end
   while s
    if rem(j,10)==0 & j>150
     beep
     disp('End of data?')
    elseif j>300 & (bval(4)~=6 | j>60000)
     disp('End of data!'), err=1; i=i-1; odate=[]; return
    end
    if bval(1)==0 | i>bval(2), return, end
    [s,fname]=unix(['ls -l ' filename]); j=j+1; pause(.6)
    s=s+strcmp(fname,odate);
   end
   filename=strtok(fname(end:-1:1)); filename=filename(end:-1:1);
   s=2-exist(filename,'file');
  end
  odate=fname;
 else
  if ~strcmp(odate,rtdir)
   [s,d]=unix(['ls -1 ' rtdir '/[0-9]*.mat']); odate=rtdir;
   if s~=0
    disp('No data!'), err=1; i=i-1; odate=[]; return
   end
  end
  [filename,d]=strtok(d,10);
  if isempty(filename)
   if rtdir(end)==filesep, rtdir=rtdir(1:end-1); end
   [j,s]=fileparts(rtdir); s=sscanf(s,'%04d%02d%02d_%02d',4);
   if length(s)==4
    s=datevec(datenum([s' 0 0])+1.01/24);
    s=fullfile(j,sprintf('%04d%02d%02d_%02d',s(1:4)));
    if exist(s,'dir')
     [j,d]=unix(['ls -1 ' s '/[0-9]*.mat']);
     if j==0
      rtdir=s; odate=s; [filename,d]=strtok(d,10);
     end
    end
   end
   if isempty(filename)
    disp('End of data!'), err=1; i=i-1; odate=[]; return
   end
  end
 end
 [s,df]=unix(['ls -l ' filename]);
 for j=1:5, [nbytes,df]=strtok(df); end
 if isempty(nbytes)
  disp('End of data!'), err=1; i=i-1; odate=[]; return
 end
 nbytes=str2num(nbytes);
 if obytes & nbytes~=obytes
%	 obytes,nbytes
  j=j-1; odate=[]; return
 end
 obytes=nbytes;
 load(filename)
% fprintf('%.0f %s\n',tosecs(d_parbl(1:6)),filename);
 dd_data=dd_data+d_data;
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
