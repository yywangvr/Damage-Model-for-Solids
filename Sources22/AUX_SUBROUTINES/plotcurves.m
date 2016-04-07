function plotcurves
% Plot stress vs strain (callback function)
% -----------------------------------------


% ************************
%1) Extract DATA from gcf
% ************************
DATA = guidata(gcf);

%2) Defining variables (local names)
%   like alfa_03 = getfield(DATA.VAR.alfa_03)
%---------------------------------------------
VARIABLES = fieldnames((DATA.VAR)) ;
for ivar = 1:length(VARIABLES)
    STRE = [VARIABLES{ivar},' = getfield(DATA.VAR,VARIABLES{ivar});' ];
    eval(STRE) ;
end
% Name = Data.Name
% ----------------
fn = fieldnames(DATA);
for i = 1:length(fn) ;
    STR = [fn{i},' = getfield(DATA,fn{i});'];
    eval(STR) ;
end
fhandle = guihandles(gcf) ; % --> Tag





% %%%%%%%%%%%%%%%%%%%%%%
% 2) PLOT X
% %%%%%%%%%%%%%%%%%%%%%%
hread    = getfield(fhandle,'xplotc');
String   = get(hread,'String')      ;
nvx      = get(hread,'Value')       ;
vpx      = String{nvx} ;

% %%%%%%%%%%%%%%%%%%%%%%
% 3) PLOT Y
% %%%%%%%%%%%%%%%%%%%%%%
hread    = getfield(fhandle,'yplotc');
String   = get(hread,'String')      ;
nvy      = get(hread,'Value')       ;
vpy      = String{nvy} ;




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
% PLOTTING
ncolores = 3 ;
colores =  ColoresMatrix(ncolores);
markers = MarkerMatrix(ncolores) ;


if strcmp(splitwind,'YES')
    subplot(2,1,2)
else
    figure(2)
    set(2,'Name','CURVES')
end
hold on
grid on
xlabel(vpx);
ylabel(vpy);

% wplotx      ={'STRAIN_1','STRAIN_2','|STRAIN_1|','|STRAIN_2|','norm(STRAIN)'};



% warning('JAHO_B')
% load('tmp.mat');

% DATA X
% ------

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
        strx = 'X(i) =sqrt((DATA.strain(i,1))^2 + (DATA.strain(i,2))^2)) ;';
    case  'TIME'
        strx = 'X(i) =TIMEVECTOR(i) ;';
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
            catch
                warning('* ')
            end
        end
        
        LISTH = {'hplotgraph','hplotLABN2'};
        strcom = {};
        for ilist = 1:length(LISTH)
            hplotlocal = LISTH{ilist} ;
            switch ErasePrPlot
                case 'YES'
                    strl = ['for ih = 1:length(',hplotlocal,');',[' if ishandle(',hplotlocal,'(ih)) & ',hplotlocal,'(ih) ~=0 ;delete(',hplotlocal,'(ih))  ;        end;'],'      end'] ;
                otherwise
                    strl = '' ;
            end
            eval([ 'if isfield(DATA,','''',hplotlocal,''') ; ',hplotlocal,' = DATA.',hplotlocal,';',strl,'; end ;']);
            %eval(['for ih = 1:length(',hplotlocal,');',[' if ishandle(',hplotlocal,'(ih)) & ',hplotlocal,'(ih) ~=0 ;delete(',hplotlocal,'(ih))  ;        end;'],'      end']);
            eval([hplotlocal,'= 0;'])
        end
        
        
        
        hplotgraph(end+1) = plot(X(1:istep1+1),Y(1:istep1+1),'Marker',markers{1},'Color',colores(1,:));
        hplotgraph(end+1) = plot(X(istep1+1:istep1+istep2),Y(istep1+1:istep1+istep2),'Marker',markers{2},'Color',colores(2,:));
        hplotgraph(end+1) = plot(X(istep1+istep2:end),Y(istep1+istep2:end),'Marker',markers{3},'Color',colores(3,:));
        
        
        % % LABEL
        % % -----
        % switch ErasePrPlot
        %     case 'YES'
        %         if isfield(DATA,'hplotLABN2')
        %             if ishandle(DATA.hplotLABN2) & DATA.hplotLABN2~=0
        %                 delete(DATA.hplotLABN2)
        %             end
        %         end
        %         hplotLABN2 = 0 ;
        %     otherwise
        %         hplotLABN2 = DATA.hplotLABN2 ;
        % end
        
        
        
        if strcmp(shownumber,'YES')
            for i = 1:istep1+1
               % strt = ['\leftarrow N =',num2str(i)];
                 strt = ['  N =',num2str(i)];
                hplotLABN2(end+1) = text(X(i),Y(i),strt,'Color',colores(1,:));
            end
            for i = istep1+2:istep1+istep2+1
              %  strt = ['\leftarrow N =',num2str(i)];
              strt = ['  N =',num2str(i)];
                hplotLABN2(end+1) = text(X(i),Y(i),strt,'Color',colores(2,:));
            end
            for i = istep1+istep2+2:istep1+istep2+istep3+1
              %  strt = ['\leftarrow N =',num2str(i)];
              strt = ['  N =',num2str(i)];
                hplotLABN2(end+1) = text(X(i),Y(i),strt,'Color',colores(3,:));
            end
            
        end
        
        
        DATA.hplotgraph = hplotgraph ;
        DATA.hplotLABN2 =hplotLABN2 ;
        
        
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %***********************************
        % Storing all variables in DATA
        %***********************************
        for ivar = 1:length(VARIABLES) ;
            num_var = VARIABLES{ivar};
            eval(['DATA.VAR.',num_var,' = ',num_var,';']);
        end
        
        
        guidata(1,DATA)
       % save(DATA.NameWs,'-append');
               save(DATA.NameWs);

      %  save(DATA.NameWs,'DATA');

