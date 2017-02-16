if isempty(d)
 d=dir(fullfile(rtdir,'*.hdf5'));
end
if exist('startfile','var')
 while ~isempty(d) && isempty(strfind(d(1).name,startfile))
  d(1)=[];
 end
end
if strcmp(local.name,'Octave')
 if isempty(pkg('list','hf5oct'))
  pkg load hdf5oct
 end
 [err,j]=system(['h5ls ' fullfile(rtdir,d(1).name) '/Data | awk ''{print $1}''']);
 if err, return, end
 j=reshape(j,9,[])'; h5d=[repmat('/Data/',size(j,1),1) j(:,1:8)];
else
 h5d=h5info(fullfile(rtdir,d(1).name));
 h5d=struct2cell(h5d.Groups(1).Groups); h5d=char(h5d(1,:));
end 
h5=1;
