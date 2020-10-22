global bval rtdir
rtg_startup
if isempty(rtdir)
%rtdir='../elin/decelin';
 bval=[];
end
if strcmp(local.name,'Octave') && (local.ver<=3 || ~strcmp(graphics_toolkit,'qt'))
% Jupyter?
 global webtg selax
 rtdir=input(sprintf('First data directory: '),'s');
 n=input(sprintf('integration dumps/secs: '));
 webtg=[n 4 0]; bval=[];
 remtg;
else
 while 1
  while ~remtg
   while ~bval(1)
    pause(1)
    if ~isgraphics(10)
     quit
    end
   end
  end
  setbval(0,1)
  while ~bval(1)
   pause(1)
   if ~isgraphics(10)
    quit
   end
  end
 end
end
