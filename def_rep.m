function varargout=def_rep(mc,mr,j,varargin)
%routine to repeat defs for different blocks
for varno=1:length(varargin)
 vartemp=varargin{varno};
 varname=inputname(varno+3);
 varargout{varno}=repmat(vartemp,mc,mr);
 if sum(strcmp(varname,{'txs' 'psig' 'back' 'cal' 'sig' 'sig0' 'bacspec' 'rawlim' 'amplim'}))
  s=ones(size(vartemp));
  s=s(:)*(1:mr*mc);
  [a,b]=size(varargout{varno});
  if mc>mr
   varargout{varno}=varargout{varno}+j*reshape(s-1,b,a).';
  else 
if any(size(varargout{varno})-size(j*(s-1)))
%[size(varargout{varno}) size(j*(s-1))]
s=reshape(s,a,b);
end
   varargout{varno}=varargout{varno}+j*(s-1);
  end
 end
end
