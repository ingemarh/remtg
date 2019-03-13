rtg_startup
global rtdir webtg def_file pldirs selax
dum=getenv('WTG'); pldirs={};
eval(dum)
set(0, 'defaultfigurevisible', 'off')
if length(getenv('EISCATSITE'))==1
 webtg(2)=2;
else
 webtg(2)=3;
end
if webtg(1)<0
 webtg(1)=-webtg(1); webtg(3)=1;
else
 webtg(3)=0;
end
if isempty(selax.wtg)
 selax=[];
else
 webtg(2)=0;
end
while ~remtg
 if strfind(lasterr,'Error occurred while evaluating listener callback.')
  break
 end
end
mkmov(pldirs,webtg(1))
exit
