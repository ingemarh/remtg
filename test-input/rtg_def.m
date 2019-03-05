o1=ones(2,1);o2=[o1 o1];o3=[o2 o1];
%txsamples
 txsam=33*[1 1 1 1];
 ntx=32*[2 2 1 1];
 txs=[0 txsam(1:3).*cumsum(ntx(1:3))];
 txdt=25.0e-6*[1 1 1 1];
%pp/timing
 psig=[0 7468;16144 23930];
 psamp=178*o2;
 plen=800e-6*o2;
 pdt=25.0e-6*o2;
 prange0=o1*[1912e-6 1087e-6];
%noise
 pbac=[4 4;1 1];
 back=[15190 15380;15826 23612];
 cal=back+178;
 bsamp=178*o2;
 csamp=12*o2;
 loopc=160;
 tcal=[228;163];
 elev=[d_parbl(9);81.6];
%sigspec
 sig=[psig+psamp [14936;31398]+30];
 sig0=[NaN*o2 [14936;31398]];
 sigtyp={'alt' 'alt' 'fdalt';'alt' 'alt' 'fdalt'};
 scomb=[o1*[0 1 0]];
 sigsamp=[178*o2 NaN*o1];
 sgates=[NaN*o2 14*o1];
 siglen=o3*800e-6;
 nbits=o3*16;
 maxlag=[31*o2 16*o1];
 sigdt=o3*25.0e-6;
 srange0=[prange0 o1*4837e-6];
%backspec
 bacspec=[15570 15698;16016 23802];
 nfftb=128*o2;
