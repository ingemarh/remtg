global bval rtdir butts
if ~exist('rtdir')
%rtdir='../elin/decelin';
 bval=[];
end
while 1
 while ~remtg
  while ~bval(1)
   pause(1)
   if ~ishandle(butts(1))
    quit
   end
  end
 end
 setbval(0,1)
 while ~bval(1)
  pause(1)
  if ~ishandle(butts(1))
   quit
  end
 end
end
