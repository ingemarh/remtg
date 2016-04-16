rtg_startup
global rtdir webtg
dum=getenv('WTG');
eval(dum)
set(0, 'defaultfigurevisible', 'off')
if getenv('EISCATSITE')
 webtg(2)=2;
else
 webtg(2)=3;
end
while ~remtg
 if strfind(lasterr,'Error occurred while evaluating listener callback.')
  break
 end
end
exit
