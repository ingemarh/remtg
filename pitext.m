function pitext
global butts bval
bval(2)=round(exp(get(butts(3),'value')));
set(butts(2),'string',num2str(bval(2)),'value',bval(2))
