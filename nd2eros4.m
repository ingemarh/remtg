% nd2eros4: Reformat of historic parameter block into eros4 type
% GUISDAP v8.3   04-04-27 Copyright EISCAT, Huuskonen&Lehtinen
%
% See also: an_start integr_data
function  [parbl,lpb]=nd2eros4(d_parbl,d_data)
if nargin<2
  global d_data vhf_tx
end

lpb=64;
parbl=-1*ones(lpb,1);
parbl(1:2:6)=floor(d_parbl(2:4)/100)+[1900;0;0];
parbl(2:2:6)=rem(d_parbl(2:4),100);
parbl([7:10 63])=d_parbl([94 99 9 6 97]).*[1;1000;.1;.1;1000];
if any(abs(d_parbl([6 9]))>[7200;950]) && parbl(2)<1984
  parbl([9 10])=parbl([9 10])/10;
end
parbl(58:62)=d_parbl(121:125); 
parbl(57)=d_parbl(92);
parbl(22)=1;
if rem(d_parbl(95),2)==1 || d_parbl(95)==64
  parbl(8)=-1;
end
%if d_parbl(95)~=0, fprintf(' Status word is %g\n',d_parbl(95)), end 
ant=[30 210 280 30;5 4 3 6];
if d_parbl(1)==2 && rem(d_parbl(127),2)==1
  d_parbl(1)=3;
end
parbl([21 41])=ant(:,d_parbl(1));
if d_parbl(1)==3
  vhf_tx=d_parbl([99 101])*1000;
  parbl(8)=sum(vhf_tx);
elseif d_parbl(1)~=2
  parbl(42)=d_parbl(11)*100;
end
parbl(64)=real(d_data(end));
if size(d_data,1)==1
 d_data=d_data(:);
 parbl(64)=parbl(64)+1;
end
