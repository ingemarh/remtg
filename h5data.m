if strcmp(local.name,'Octave')
 info=pkg('list','hdf5oct');
 if isempty(info)
  %pkg install "https://github.com/gapost/hdf5oct/archive/refs/tags/1.0.0.tar.gz"
  pkg install --forge hdf5oct
  pkg load hdf5oct
 elseif ~info{1}.loaded
  pkg load hdf5oct
 end
end
if exist('startfile','var') || isempty(d)
 d=dir(fullfile(rtdir,'*.hdf5'));
 if exist('startfile','var')
  h5=find(strcmp({d.name},startfile));
 else
  h5=1;
 end
 odate=fullfile(rtdir,d(h5).name);
 h5(2)=0;
 hi=h5info(odate,'/Data/Time'); h5(3)=hi.Dataspace.Size(2);
 h5(4:6)=Inf;
 if strcmp(local.name,'Octave')
  hi=h5info(odate,'/Data/ParBlock/ParBlock'); h5(4)=hi.Dataspace.Size(1);
  hi=h5info(odate,'/Data/L2'); h5(5)=hi.Dataspace.Size(1);
  try
   hi=h5info(odate,'/Data/L1'); h5(6)=hi.Dataspace.Size(1);
  catch,end
 end
 h5(7)=h5read(odate,'/DataBase/InfoID');
end
if h5(2)<h5(3)
 h5(2)=h5(2)+1;
else
 try
  h5(1)=h5(1)+1;
  odate=fullfile(rtdir,d(h5(1)).name);
  hi=h5info(odate,'/Data/Time'); h5(3)=hi.Dataspace.Size(2);
  h5(2)=1;
 catch
  d=[];
 end
end 
