rtg_startup
global rtdir webtg
dum=getenv('WTG');
eval(dum)
while ~remtg
 if strfind(lasterr,'Error occurred while evaluating listener callback.')
  break
 end
end
exit
