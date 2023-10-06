if strcmp(getenv('EISCATSITE'),'Hub') || usejava('desktop')
  setbval(0,1)
  close all
  clear
  global bval
else
  quit
end
