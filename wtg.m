function wtg(d,n,D,x)
%function wtg(rtdir,n,def_file,slx)
% wrapper for webtg shell script
% inputs: d start directory
%         n integration dumps/secs
%         D definition file
%         x Plot selection text string fig,subplot,routine
global rtdir webtg def_file selax pldirs
if nargin<4, x=[]; end
if nargin<3, D=[]; end
if nargin<2, n=[]; end
if nargin<1, d=[]; end
if isempty(d), d=pwd; end
if isempty(n), n=60; end
set(0,'defaultfigurevisible','off')
pldirs={};
rtdir=d;
def_file=D;
webtg=n;
if length(getenv('EISCATSITE'))==1
 webtg(2)=2;
else
 webtg(2)=3;
end
if n<0
 webtg([1 3])=[-n 1];
else
 webtg([1 3])=[n 0];
end
if isempty(x)
 selax=[];
else
 webtg(2)=0;
 selax.wtg=x;
end
while ~remtg
 if strfind(lasterr,'Error occurred while evaluating listener callback.')
  break
 end
end
mkmov(pldirs,webtg(1))
