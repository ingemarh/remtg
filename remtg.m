function [err,chpar]=remtg(chpar)
% Main rtg routine [err,chpar]=remtg(chpar)
% Version 2002-10-23
global dd_data d_ExpInfo d_parbl rd id bval butts rtdir tdev tdim site gating el radcon figs webtg
if nargin<1, chpar=[]; end
if isempty(bval)
 site=findstr('KSTVL2Z',getenv('EISCATSITE'));
 if isempty(site), site=1;
 elseif site==3 & ~isempty(findstr(getenv('RXHOST'),'v5011')), site=4;
 end
 bval=[1 1 1 8-isempty(rtdir)*(8-site) 0 1 0 1 0 0 0];
 if strcmp('rtg',getenv('XTERM_WM_NAME')), bval(5)=1;
 elseif ~isempty(webtg), bval([2 3 5 10])=[webtg([1 1]) 1 1];
 end
end
wsite={'Kiruna','Sodankyla','Tromso UHF','Tromso VHF','ESR1','ESR2','Zod'};
radcon=[6e11,6e11,6e11,2e11,6e11,3e11,5e11];
antenna=[5 6 4 3 1 2 7]; tdev=[];
if isempty(butts) | ~ishandle(butts(1))
 rtgbuttons(10)
end
if bval(4)<9
 [ints,filename,nbytes,err]=int_rt;
 if err
  if ints==0, return, end
 end
 dd_data=dd_data/ints;
 if bval(1)==0, return, end
else
 ints=d_parbl(7)/5;
 err=0;
 setbval(0,1)
end
rd=real(dd_data); id=imag(dd_data); id(find(~id))=NaN;
pow=d_parbl(8); site=antenna(d_parbl(41));
head=sprintf(' %04d-%02d-%02d %02d%02d:%05.2f %gs %.0fkW %.1f/%.1f',d_parbl(1:7),pow/1000,rem(d_parbl(10),360),d_parbl(9));
%raw data
sms=[d_ExpInfo head]; figs=[]; sitet=[' ' char(wsite(site))];
t1=raw(10,['Raw data' sitet],sms);
if bval(4)<8
 if findstr(filename,'RT')
  set(t1,'string','Not recording')
 else
  [s,df]=unix(['df -k ' filename]);
  for i=1:11, [d,df]=strtok(df); end 
  if isempty(d)
   set(t1,'string',sprintf('Recording@%s',strtok(filename(2:end),'/')))
  else 	  
   d=str2num(d);
   set(t1,'string',sprintf('Recording@%s (%.0f Mb=%.1f h)',strtok(filename(2:end),'/'),d/1024,d/nbytes*1024*d_parbl(7)/ints/3600))
  end 
 end 
 sms=sprintf('%s\n%s',sms,get(t1,'string'));
else
 set(t1,'visible','off')
end 

% default chpar values
psig=[]; ntim=60; thead=[]; sigtyp=[]; bacspec=NaN;

[def_file,chpar]=find_chpar(chpar);
try
if ~isempty(def_file), run(def_file); end
head=[chpar head];
if exist('rawlim','var') & ~isempty(rawlim)
 nrp=size(rawlim,1); nraw=0;
 while nrp>0
  nrf=ceil(nrp/4); nrnow=ceil(nrp/nrf); nraw=nraw+1;
  raw(nraw+10,['Raw ' num2str(nraw) sitet],head,rawlim(1:nrnow,:));
  rawlim=rawlim(nrnow+1:nrp,:); nrp=nrp-nrnow;
 end
end
if exist('amplim','var') & ~isempty(amplim)
 nrp=size(amplim,1); nraw=0;
 while nrp>0
  nrf=ceil(nrp/4); nrnow=ceil(nrp/nrf); nraw=nraw+1;
  raw(nraw+40,['Amplitudes ' num2str(nraw) sitet],head,amplim(1:nrnow,:),1);
  amplim=amplim(nrnow+1:nrp,:); nrp=nrp-nrnow;
 end
end
noch=size(psig,1);
if noch==0 & strcmp(get(butts(7),'visible'),'on')
 set(butts([7 11]),'visible','off')
 set(butts(6),'visible','on')
elseif noch>0 & strcmp(get(butts(7),'visible'),'off')
 set(butts([7 11]),'visible','on')
 set(butts(6),'visible','off','value',1)
 bval(6)=1;
end
for ch=1:noch
 nacf=0; for s=1:size(sigtyp,2), nacf=nacf+~isempty(char(sigtyp(ch,s))); end
 nax=2+nacf;
 if isfinite(bacspec(ch)), nax=nax+1; end
 ax=getaxes(ch+20,nax/2,2,['Pulse ' num2str(ch) sitet],head);
 % back cal /pp
 if ~exist('loopc','var'), loopc=100*d_parbl(7)/ints; end
 [tsys,blev]=noise(ch+20,ax(2),bsamp(ch,:),csamp(ch,:),back(ch,:),cal(ch,:),loopc);
 sms=sprintf('%s\n%s',sms,get(get(ax(2),'title'),'string'));
 tnormal=[40 40 90 300 50 50 30];
 tsys(find(isnan(tsys)))=tnormal(site);
 %timing/pp
 if exist('elev','var')
  el=elev(ch,1);
 else
  el=d_parbl(9);
 end
 if exist('bfac','var')
  blev=blev./bfac(ch,find(isfinite(bfac(ch,:))));
  if length(blev)>length(tsys), tsys(end+1:length(blev))=mean(tsys); end
 end
 c2t=tsys(1:length(blev))./blev; pb=blev;
 if exist('pbac','var'), pb=pbac(ch,:).*blev; end
 if exist('prange0','var')
  pp(ch+20,ax(1),psig(ch,:),psamp(ch,:),plen(ch,:),pdt(ch,:),pb,c2t,prange0(ch,:))
 else
  timing(ch+20,ax(1),psig(ch,:),psamp(ch,:),plen(ch,:),pdt(ch,:),pb,c2t)
  sms=sprintf('%s %s',sms,get(get(ax(1),'title'),'string'));
 end
 set(ax(1),'ygrid','on')
 % back spec /spec
 gating=1; bacf=0;
 if isfinite(bacspec(ch))
  if exist('maxlagb','var') & maxlagb(ch)>0
   bacf=backspec(ch+20,ax(nax),maxlag(ch,1),maxlagb(ch),bacspec(ch,:),backsamp(ch,:),sigdt(ch,1),tsys);
  elseif exist('nfftb','var')
   fftpulse(ch+20,ax(nax),bacspec(ch,:),nfftb(ch,:),sigdt(ch,1),tsys);
  end
 end
 % sig spec /spec
 kperc=mean(tsys)/mean(blev);
 for s=1:nacf
  if ~exist('srange0','var')
   s0=0;
   if site<3, s0=-1; end
  else
   s0=srange0(ch,s);
  end
  styp=char(sigtyp(ch,s));
  if exist('lag0','var')
   lag00=lag0(ch,s); w00=w_lag0(ch,s);
  else
   lag00=NaN; w00=NaN;
  end
  if exist('sgating','var')
   gating=sgating(ch,s);
  else
   gating=1;
  end
  if strcmp(styp,'rem')
   rempulse(ch+20,ax(2+s),sig(ch,s),sigsamp(ch,s),maxlag(ch,s),siglen(ch,s),bacf,sigdt(ch,s),kperc);
  elseif strcmp(styp,'alt')
   altpulse(ch+20,ax(2+s),sig(ch,s),sigsamp(ch,s),maxlag(ch,s),siglen(ch,s),nbits(ch,s),sigdt(ch,s),s0,kperc)
  elseif strcmp(styp,'long')
   longpulse(ch+20,ax(2+s),sig(ch,s),sigsamp(ch,s),maxlag(ch,s),siglen(ch,s),bacf,sigdt(ch,s),s0,kperc);
  elseif strcmp(styp,'puls2')
   pulspulse(ch+20,ax(2+s),sig(ch,s),sigsamp(ch,s),maxlag(ch,s),siglen(ch,s),npulses(ch,s),sigdt(ch,s),slagincr(ch,s),swlag(ch,s),lag00,w00,s0,kperc);
  elseif strcmp(styp,'fft')
   fftpulse(ch+20,ax(2+s),sig(ch,s),nffts(ch,s),sigdt(ch,s),kperc,siglen(ch,s),sgates(ch,s),s0);
  elseif strcmp(styp,'myalt')
   myalt(ch+20,ax(2+s),sig(ch,s),sigsamp(ch,s),maxlag(ch,s),siglen(ch,s),nbits(ch,s),sigdt(ch,s),s0,kperc)
  else
   set(ax(2+s),'visible','off')
  end
 end
 set(ax((nax+1):end),'visible','off')
end
if ~isempty(tdev)
 lt=length(tdev);
 if ~exist('tdim','var') | size(tdim,1)~=lt
  tdim=ones(lt,ntim)*NaN;
 end
 tdim=[tdev tdim(:,1:(ntim-1))];
 if bval(10)
  timedev(30,ntim,thead,head)
 end
end
catch
 disp(lasterr)
end
if bval(5)
 mkweb(sms)
elseif ~isempty(rtdir)
 pause(5)
end
