function wtg(dd,n,D,slx)
%function wtg(rtdir,n,def_file,slx)
% wrapper for webtg shell script
% inputs: rtdir    start directory
%         n        integration dumps/secs
%         def_file definition file
%         slx      Plot selection text string fig,subplot,routine
global rtdir webtg def_file selax pldirs bval local
if nargin<4, slx=[]; end
if nargin<3, D=[]; end
if nargin<2, n=[]; end
if nargin<1, dd=[]; end
if isempty(dd), dd=pwd; end
if isempty(n), n=60; end
if isempty(local)
 rtg_startup
end
set(groot,'defaultfigurevisible','off')
if isgraphics(10), close(10), end
pldirs={};
rtdir=dd; bval=[];
def_file=D;
if ~isempty(def_file) && ~exist([def_file '.m'])
 error('remtg:wtg',sprintf('%s not found',def_file))
end
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
if isempty(slx)
 selax=[];
else
 webtg(2)=0;
 selax.wtg=slx;
end
while ~remtg
 if strfind(lasterr,'Error occurred while evaluating listener callback.')
  break
 end
end
mkmov(pldirs,webtg(1))
