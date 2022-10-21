function [status,result]=rtgix(cmd)
%Wrapper for avoiding mathworks libraries
[status,result]=unix(['LD_LIBRARY_PATH="" ' cmd]);
