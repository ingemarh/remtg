function err=remtg
% Main rtg routine err=remtg
global dd_data d_ExpInfo d_parbl rd id bval butts rtdir tdev tdim site gating el radcon figs webtg d_raw local def_file sitecode combine combhold tail maxsize_acf selax
tnormal=[50 50 300 90 40 40 30 50 200]; tdev=[];
if isempty(bval)
 radcon=[3e11 6e11 2e11 6e11 6e11 6e11 5e11 6e11 3e11];
 sitecode.web={'ESR 32m','ESR 42m','Troms&oslash; VHF','Troms&oslash; UHF','Kiruna','Sodankyl&auml;','Hot','ESR 32p','QuJing'};
 sitecode.long={'ESR 32m','ESR 42m','Tromso VHF','Tromso UHF','Kiruna','Sodankyla','Hot','ESR 32p','QuJing'};
 sitecode.short={'Old','Disk','32m','42m','VHF','UHF','Kir','Sod','Hot','32p','Quj'};
 sitecode.mini='L2VTKSHPQ';
 sitecode.low='llvurr pq';
 site=findstr(sitecode.mini,getenv('EISCATSITE'));
 xwn=getenv('XTERM_WM_NAME');
 if isempty(site), site=5; err=1;
 elseif site==4 && ~isempty(findstr(xwn,'VHF')), site=3;
 end
 bval=[1 1 1 isempty(rtdir)*site 0 1 0 1 0 0 0];
 if findstr('rtg',xwn)
  bval(5)=1;
 elseif ~isempty(webtg)
  bval([2 3 5 10])=[webtg([1 1 2]) 1]; err=0;
  if strcmp(local.name,'Octave') && strcmp(graphics_toolkit,'gnuplot'), bval(10)=0; end
 end
end
if bval(5)<2 && (isempty(butts) || ~ishandle(butts(1)))
 rtgbuttons(10)
 if exist('err','var'), return, end
end
if bval(4)>=0
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
 filename=[];
end
rd=real(dd_data); id=imag(dd_data); id(find(id==0))=NaN;
site=d_parbl(41); intt=d_parbl(7);
tim=datestr(datenum(round(d_parbl(1:6))),31); tim=[tim(1:13) tim(15:19)];
if site==14, txpow=d_parbl(65); else, txpow=d_parbl(8)/1000; end
head=sprintf(' %s %gs %.0fkW %.1f/%.1f',tim,intt,txpow,rem(d_parbl(10),360),d_parbl(9));
%raw data
sms=[d_ExpInfo head]; figs=[]; sitet=[' ' char(sitecode.long(site))];
t1=raw(10,['Raw data' sitet],sms);
if bval(4)>0
 if findstr(filename,'RT')
  set(t1,'string','Not recording')
 else
  [s,df]=unix(['df -k ' filename]);
  for i=1:11, [d,df]=strtok(df); end
  if isempty(d)
   set(t1,'string',sprintf('Recording@%s',strtok(filename(2:end),'/')))
  else
   d=str2num(d);
   set(t1,'string',sprintf('Recording@%s (%.0f Mb=%.1f h)',strtok(filename(2:end),'/'),d/1024,d/nbytes*1024*intt/ints/3600))
  end
 end
 sms=sprintf('%s\n%s',sms,get(t1,'string'));
else
 set(t1,'visible','off')
end
if local.ver<=3, set(t1,'string',[head '  ' get(t1,'string')]), end
% default chpar values
psig=[]; ntim=60; thead=[]; sigtyp=[]; bacspec=NaN; tail=.7;
maxsize_acf=[256 256];
if site==5 || site==6
 tail=0;
end
chpar=find_chpar(filename);
try
if ~isempty(def_file)
 if local.ver>3
  run(def_file);
 else
  run([def_file '.m']);
 end
end
head=[chpar head];
if exist('rawlim','var') && ~isempty(rawlim)
 nrp=size(rawlim,1); nraw=0;
 while nrp>0
  nrf=ceil(nrp/4); nrnow=ceil(nrp/nrf); nraw=nraw+1;
  raw(nraw+10,['Raw ' num2str(nraw) sitet],head,rawlim(1:nrnow,:));
  rawlim=rawlim(nrnow+1:nrp,:); nrp=nrp-nrnow;
 end
end
if exist('txs','var') && ~isempty(txs)
 nrp=size(txs,1); nraw=0;
 while nrp>0
  nrf=ceil(nrp/4); nrnow=ceil(nrp/nrf); nraw=nraw+1;
  tx(nraw+50,['Transmitter samples ' num2str(nraw) sitet],head,txs(:),txsam(:),ntx(:),txdt(:))
  nrp=nrp-nrnow;
 end
end
if exist('amplim','var') && ~isempty(amplim)
 nrp=size(amplim,1); nraw=0;
 while nrp>0
  nrf=ceil(nrp/4); nrnow=ceil(nrp/nrf); nraw=nraw+1;
  raw(nraw+40,['Amplitudes ' num2str(nraw) sitet],head,amplim(1:nrnow,:),1);
  amplim=amplim(nrnow+1:nrp,:); nrp=nrp-nrnow;
 end
end
noch=size(psig,1);
if bval(5)<2
 if noch==0 && strcmp(get(butts(7),'visible'),'on')
  set(butts([7 11]),'visible','off')
  set(butts(6),'visible','on')
 elseif noch>0 && strcmp(get(butts(7),'visible'),'off')
  set(butts([7 11]),'visible','on')
  set(butts(6),'visible','off','value',1)
  bval(6)=1;
 end
end
if ~exist('tcal','var')
 tcal=d_parbl(21)*ones(noch,1);
end
for ch=1:noch
 nacf=0; for s=1:size(sigtyp,2), nacf=nacf+~isempty(char(sigtyp(ch,s))); end
 nax=nacf; s=2;
 if exist('scomb','var')
  combine=scomb(ch,:); nax=nacf-sum(combine); combhold=[];
 else
  combine=[];
 end
 if any(isfinite(psig(ch,:))), nax=nax+1; end
 if any(bsamp(ch,:)), nax=nax+1; end
 if isfinite(bacspec(ch,1)), nax=nax+1;
 elseif nax==1, s=1; end
 ax=getaxes(ch+20,nax/s,s,['Pulse ' num2str(ch) sitet],head);
 % back cal /pp
 if ~exist('loopc','var'), loopc=100*intt/ints; end
 if sum(bsamp(ch,:))
  bax=ax(1+any(isfinite(psig(ch,:))));
  [tsys,blev]=noise(ch+20,bax,bsamp(ch,:),csamp(ch,:),back(ch,:),cal(ch,:),loopc,tcal(ch));
  sms=sprintf('%s\n%s',sms,get(get(bax,'title'),'string'));
  blev(find(~blev))=1;
  tsys(find(~isfinite(tsys)))=tnormal(site);
  cax=2;
 elseif exist('blev')
  blev=blev(1); cax=1;
 end
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
 if sum(isfinite(psig(ch,:)))
  if ~exist('prange0','var'), prange0=zeros(size(psig)); end
  pp(ch+20,ax(1),psig(ch,:),psamp(ch,:),plen(ch,:),pdt(ch,:),pb,c2t,prange0(ch,:))
  if nax==1 && exist('pplegend','var') && local.x
   legend(ax(1),pplegend(ch,:),-1), legend(ax(1),'boxoff')
  end
  sms=sprintf('%s %s',sms,get(get(ax(1),'title'),'string'));
 else
  cax=cax-1;
 end
 set(ax(1),'ygrid','on')
 % back spec /spec
 gating=1; bacf=0;
 if isfinite(bacspec(ch))
  if ~exist('nfftb','var'), nfftb=NaN*ones(size(bacspec)); end
  if ~exist('backsamp','var'), backsamp=zeros(size(bacspec)); end
  if ~exist('maxlagb','var'), maxlagb=zeros(size(bacspec)); end
  bacf=backspec(ch+20,ax(nax),maxlag(ch,1),maxlagb(ch),bacspec(ch,:),backsamp(ch,:),nfftb(ch,:),sigdt(ch,1),tsys(1));
 end
 % sig spec /spec
 s=min(length(tsys),length(blev));
 kperc=mean(tsys(1:s))/mean(blev(1:s));
 for s=1:nacf
  if isempty(combine) || s==1
   axs=ax(cax+s);
  elseif ~combine(s-1)
   axs=ax(cax+s-length(find(combine(1:s-1))));
  end
  if ~isempty(combine) && combine(s)
   combine(s)=axs;
  end
  if ~exist('srange0','var')
   s0=0;
  else
   s0=srange0(ch,s);
  end
  styp=char(sigtyp(ch,s));
  if exist('lag0','var')
   lag00=lag0(ch,s); w00=w_lag0(ch,s);
  else
   lag00=NaN; w00=NaN;
  end
  if exist('stransp','var')
   transp=stransp(ch,s);
  else
   transp=[];
  end
  if exist('sgating','var')
   gating=sgating(ch,s);
  else
   gating=1;
  end
  if exist('bacfac','var')
   bacfact=bacfac(ch,s);
  else
   bacfact=1;
  end
  if strcmp(styp,'rem')
   rempulse(ch+20,axs,sig(ch,s),sigsamp(ch,s),maxlag(ch,s),siglen(ch,s),bacf*bacfact,sigdt(ch,s),kperc);
  elseif strcmp(styp,'alt')
   altpulse(ch+20,axs,sig(ch,s),sigsamp(ch,s),maxlag(ch,s),siglen(ch,s),nbits(ch,s),sigdt(ch,s),s0,kperc)
  elseif strcmp(styp,'long')
   longpulse(ch+20,axs,sig(ch,s),sigsamp(ch,s),maxlag(ch,s),siglen(ch,s),bacf*bacfact,sigdt(ch,s),s0,kperc);
  elseif strcmp(styp,'puls2')
   pulspulse(ch+20,axs,sig(ch,s),sigsamp(ch,s),maxlag(ch,s),siglen(ch,s),npulses(ch,s),sigdt(ch,s),slagincr(ch,s),swlag(ch,s),lag00,w00,s0,kperc,transp);
  elseif strcmp(styp,'fft')
   fftpulse(ch+20,axs,sig(ch,s),nffts(ch,s),sigdt(ch,s),kperc,siglen(ch,s),sgates(ch,s),s0);
  elseif strcmp(styp,'fdalt')
   fd_alt(ch+20,axs,sig(ch,s),sgates(ch,s),maxlag(ch,s),siglen(ch,s),nbits(ch,s),sigdt(ch,s),s0,kperc,sig0(ch,s))
  elseif strcmp(styp,'myalt')
   myalt(ch+20,axs,sig(ch,s),sigsamp(ch,s),maxlag(ch,s),siglen(ch,s),nbits(ch,s),sigdt(ch,s),s0,kperc)
  else
   set(axs,'visible','off')
  end
 end
 set(ax((nax+1):end),'visible','off')
end
if ~isempty(tdev)
 lt=length(tdev);
 if ~isstruct(tdim) || size(tdim.data,1)~=lt
  tdim.data=ones(lt,ntim)*NaN; tdim.time=tdim.data(1,:);
 end
 tdim.data=[tdev tdim.data(:,1:(ntim-1))];
 tdim.time=[datenum(d_parbl(1:6)) tdim.time(1:(ntim-1))];
 if bval(10)
  timedev(30,ntim,thead,head)
 end
end
if ~isempty(selax) && exist(selax.fun,'file')
 clear(selax.fun)
 run(selax.fun)
end
catch
 disp(lasterr)
end
if bval(5)
 mkweb(sms)
elseif ~isempty(rtdir) && isempty(selax)
 pause(1)
end
