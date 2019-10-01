%skript to run when starting without shell
addpath(pwd)
global local
if ~ispc
 local.tempdir=fullfile(getenv('HOME'),'tmp');
end
rtg_startup
global rtdir selax webtg
selax=[]; webtg=[1 4 0];
%change above the parameters if needed
%may continue as follows in jupyter
%rtdir='taro_CAPERmsp_1.00_SP@32m/20141202_06'; remtg;
