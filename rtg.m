global bval rtdir butts
rtg_startup
if isempty(rtdir)
%rtdir='../elin/decelin';
 bval=[];
end
if strcmp(local.name,'Octave') && (local.ver<=3 || strcmp(graphics_toolkit,'gnuplot'))
% Jupyter?
 global webtg selax
 webtg=[1 4 0]; selax=[];
 rtdir=input(sprintf('First data directory: '),'s');
 remtg
else
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
end
