function setbval(val,butt)
global butts bval
if ~isempty(butts) && isgraphics(butts(1)) && bval(5)<2
 if nargin>0
  set(butts(butt),'value',val)
 end
 for i=1:length(bval)
  bval(i)=get(butts(i),'value');
 end
 bval(4)=bval(4)-2;
elseif nargin>0
 bval(butt)=val;
end
