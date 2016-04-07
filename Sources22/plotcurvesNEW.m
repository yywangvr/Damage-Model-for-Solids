function plotcurvesNEW(DATA,vpx,vpy,LABELPLOT,vartoplot)
% Plot stress vs strain (callback function)
% -----------------------------------------





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
% PLOTTING
ncolores = 3 ;
colores =  ColoresMatrix(ncolores);
markers = MarkerMatrix(ncolores) ;


subplot(2,1,2)

hold on
grid on
xlabel(vpx);
ylabel(vpy);


switch  vpx
    case 'STRAIN_1'
        strx = 'X(i) = DATA.strain(i,1);' ;
        %strx = 'X(i) = max(DATA.strain(i,1),DATA.strain(i,2));' ;
    case 'STRAIN_2'
        strx = 'X(i) = DATA.strain(i,2);' ;
        %strx = 'X(i) = min(DATA.strain(i,1),DATA.strain(i,2));' ;
    case '|STRAIN_1|'
        strx = 'X(i) = abs(DATA.strain(i,1));' ;
        %strx = 'X(i) = abs(max(DATA.strain(i,1),DATA.strain(i,2)));' ;
    case '|STRAIN_2|'
        strx = 'X(i) = abs(DATA.strain(i,2));' ;
        %strx = 'X(i) = abs(min(DATA.strain(i,1),DATA.strain(i,2)));' ;
    case  'norm(STRAIN)'
      %  strx = 'X(i) =sqrt((DATA.strain(i,1))^2 + (DATA.strain(i,2))^2)) ;';
         % b='b=DATA.strain(i,1)^2+  DATA.strain(i,2)';
         strx = 'b=DATA.strain(i,1)^2+  DATA.strain(i,2)^2; X(i) =sqrt(b);' ;
    case  'TIME'
        strx = 'X(i) =DATA.TIMEVECTOR(i) ;';
    otherwise
        for iplot = 1:length(LABELPLOT)
            switch vpx
                case LABELPLOT{iplot}
                    strx =  ['X(i) = vartoplot{i}(',num2str(iplot),') ;'];
            end
        end
end


X = 0 ;
for i = 1:size(DATA.strain,1)
    eval(strx) ;
end

% DATA Y
% ------

switch  vpy
    case 'STRESS_1'
        stry = 'Y(i) = DATA.sigma_v{i}(1,1);' ;
        %stry = 'Y(i) = max(DATA.sigma_v{i}(1,1),DATA.sigma_v{i}(2,2));' ;
    case 'STRESS_2'
        stry = 'Y(i) = DATA.sigma_v{i}(2,2);' ;
        %stry = 'Y(i) = min(DATA.sigma_v{i}(1,1),DATA.sigma_v{i}(2,2));' ;
    case '|STRESS_1|'
        %stry = 'Y(i) = abs(max(DATA.sigma_v{i}(1,1),DATA.sigma_v{i}(2,2)));' ;
        stry = 'Y(i) = abs(DATA.sigma_v{i}(1,1));' ;
    case '|STRESS_2|'
        %stry = 'Y(i) = abs(min(DATA.sigma_v{i}(1,1),DATA.sigma_v{i}(2,2)));' ;
        stry = 'Y(i) = abs(DATA.sigma_v{i}(2,2));' ;
    case  'norm(STRESS)'
        stry = 'Y(i) = sqrt((DATA.sigma_v{i}(1,1))^2+(DATA.sigma_v{i}(2,2))^2);' ;
    case  'DAMAGE VAR.'
        stry = 'Y(i) = sqrt((DATA.sigma_v{i}(1,1))^2+(DATA.sigma_v{i}(2,2))^2);' ;
    case 'C11 algorithmic tangent'
        stry='Y(i)=DATA.ce_v{i}(1,1);';
    otherwise
        
        
        
        for iplot = 1:length(LABELPLOT)
            switch vpy
                case LABELPLOT{iplot}
                    stry =  ['Y(i) = vartoplot{i}(',num2str(iplot),') ;'];
            end
        end
        
end

 Y = 0 ;
for i = 1:length(DATA.sigma_v)
    try
        eval(stry);
    
    end
end



plot(X,Y,'Marker',markers{1},'Color',colores(1,:));
G=X;H=Y;
save('s3s5.mat','G','H')

for i=1:length(X)
    text(X(i),Y(i),num2str(i));
end


