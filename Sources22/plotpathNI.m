function [hplotp, hplotl]=plotpathNI(SIGMAP,istep)
% See select_path
% It plots stress path

% Plot iloc-th stretch
% --------------------
PNT = SIGMAP(1,:) ;
hplotp = plot(PNT(1),PNT(2),'ro');
hplotl = [] ;
for iloc = 1:size(SIGMAP,1)-1
    INCSIGMA = SIGMAP(iloc+1,:)-SIGMAP(iloc,:) ;
    for i = 1:istep(iloc)
        PNTb = PNT ;
        % PNT = PNT+INCSIGMA* ;
        PNT = PNT+INCSIGMA/(istep(iloc));
        LINE = [PNTb ; PNT];
        hplotp(end+1) = plot(PNT(1) ,PNT(2),'ro');
        hplotl(end+1) = plot(LINE(:,1) ,LINE(:,2),'r','LineWidth',1,'LineStyle','--');
    end
end