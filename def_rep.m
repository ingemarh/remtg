function varargout=def_rep(mc,mr,j,varargin)
%routine to repeat defs for different blocks
for varno=1:length(varargin)
 vartemp=varargin{varno};
 varname=inputname(varno+3);
 varargout{varno}=repmat(vartemp,mc,mr);
 if strmatch(varname,{'txs' 'psig' 'back' 'cal' 'sig' 'sig0' 'backspec'},'exact')
  s=ones(size(vartemp));
  s=s(:)*(1:mr*mc);
  [a,b]=size(varargout{varno});
  varargout{varno}=varargout{varno}+j*reshape(s-1,b,a).';
 end
end
