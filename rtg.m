global bval rtdir butts
fprintf('EISCAT Real Time Graph vs %g\n',2.5)
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
