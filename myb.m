function myb(nl,w)
global bval
if ~isempty(bval), setbval, end
if nargin==0, nl=[]; end
if isempty(nl)
 nl=size(get(gcf,'colormap'),1);
end
if nargin<2 || ~bval(9)
 f=zeros(nl,3)+.5; j=0;
 b=round(1:(nl-1)/7:nl);
 f(b,:)=[0 0 0 0 1 1 1 1
         0 0 1 1 1 0 0 1
         0 1 1 0 0 0 1 1]';
 for l=2:nl
  if f(l,1)==.5
   j=j+1;
  else
   for ll=l-j:l-1
    f(ll,:)=((ll-l+j+1)*f(l,:)-(ll-l)*f(l-j-1,:))/(j+1);
   end
   j=0;
  end
 end
else
 f=gray(nl);
end
h=get(0,'children');
if ~isempty(h), set(h,'colormap',f); end
set(0,'defaultfigurecolormap',f)
