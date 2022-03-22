%global Ana M0 M1 M2
[dum,d]=strtok(d_ExpInfo);
File=fullfile(local.userdir,[strtok(d) '_specfit.mat'])
if exist(File)
  load(File)
else
  Results=[]; Time=[];
end
GG=3:66;
[S,F]=acf2spec(selax.sacf(:,GG),selax.lag');
[NF,NG]=size(S);
H=(selax.r0+GG*selax.dt)*.15e6;
F=F';
Dl=mean(diff(selax.lag));
Df=mean((diff(F)));
%moments
M0=sum(S);
M1=sum((F*ones(1,NG)).*S);
M2=sum(((F*ones(1,NG)-ones(NF,1)*M1).^2).*S);
M=[M0' M1' M2'];
if 0
  Model='fit_gauss';
% Model='fit_lorentz';
  M0(find(M0)<0)=eps;
  M2(find(M2)<0)=eps;
  X0=[log(M0)' asinh(M1/2)' log(M2)']
  O=optimset('Display','off');
end
Results=[Results;[H' M]];
Time=[Time;[datenum(d_parbl(1:6)) NG]];
save(File,'-mat','Time','Results')
