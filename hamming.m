function w=hamming(n)
w=.54-.46*cos(2*pi*(0:n-1)'/(n-1));
