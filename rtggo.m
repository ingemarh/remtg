%skript to run when starting without shell
addpath(pwd)
global local
if ~ispc
 local.tempdir=fullfile(getenv('HOME'),'tmp');
end
rtg_startup
