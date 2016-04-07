function strain = calstrain_NI(istep,STRAIN)
% See select_path
mstrain = size(STRAIN,2) ;
strain = zeros(sum(istep)+1,mstrain) ;
acum = 0 ;
PNT = STRAIN(1,:) ;
for iloc = 1:length(istep)
    INCSTRAIN = STRAIN(iloc+1,:)-STRAIN(iloc,:);
    for i = 1:istep(iloc)
        acum = acum + 1;
        PNTb = PNT ;
       % PNT = PNT+INCSTRAIN ;
       PNT = PNT + INCSTRAIN/istep(iloc);
        strain(acum+1,:) = PNT ;
    end

end