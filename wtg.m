rtg_startup
global rtdir webtg
dum=getenv('WTG');
eval(dum)
if getenv('EISCATSITE')
 webtg(2)=1;
else
 webtg(2)=2;
end
while ~remtg
 if strfind(lasterr,'Error occurred while evaluating listener callback.')
  break
 end
end
exit
