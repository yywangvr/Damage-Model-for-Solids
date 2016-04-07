function showoptions
% Set preferences
% ---------------


% ************************
%1) Extract DATA from gcf
% ************************
DATA = guidata(gcf);
load(DATA.NameWs);

%2) Defining variables (local names)
%   like alfa_03 = getfield(DATA.VAR.alfa_03)
%---------------------------------------------
VARIABLES = fieldnames((DATA.VAR)) ;
for ivar = 1:length(VARIABLES)
    STRE = [VARIABLES{ivar},' = getfield(DATA.VAR,VARIABLES{ivar});' ];
    eval(STRE) ;
end

%%%%
% Check if axiskind change its values
% -----------------------------------
LISTErasePrPlot = {'YES','NO'} ;
LISTaxiskind = {'AUTO','NON-AUTO','CURRENT'} ;
if exist([pathdata,'showoopt.mat'])
    
    try
        load([pathdata,'showoopt.mat']) ; % --> SaveAns
        axiskindBEF = LISTaxiskind(SaveAns{2}) ;
        ErasePrPlotBEF = LISTErasePrPlot(SaveAns{3}) ;
        ErasePrPlotBEF_path = LISTErasePrPlot(SaveAns{5}) ;
    catch 
        axiskindBEF = 'AUTO' ;
        ErasePrPlotBEF = 'YES' ;
        ErasePrPlotBEF_path  = 'YES' ;
    end
else
    axiskindBEF = 'AUTO' ;
    ErasePrPlotBEF = 'YES' ;
    ErasePrPlotBEF_path  = 'YES' ;

end


%%%%

% warning('JAHO')
% load('/home/joaquin/USO_COMUN_MATLAB/COMMON_FILES/GuillPracMatlab/AUX_SUBROUTINES/tmp_miiiiiii.mat')

try
[shownumber,axiskind,ErasePrPlot,splitwind,ErasePrPlot_path] = ...
    MenuMake('OPTIONS','on',[pathdata,'showoopt.mat'] ,0, ...
    'Label stress points ? ',[2 10],{'YES','NO'},2,0,[1],0, ...
    'AXES DEFINITION: ',[2 10],LISTaxiskind,1,0,[1],0, ...
    'DELETE PREVIOUS PLOTS? ',[2 10],LISTErasePrPlot,1,0,[1],0,...
    'SPLIT WINDOW? ',[2 10],{'YES','NO'},1,0,[1],0, ...
    'DELETE INPUT STRESS PATH? ',[2 10],LISTErasePrPlot,1,0,[1],0);
catch
    ErasePrPlot_path = 'YES';
end

if ~strcmp(ErasePrPlotBEF,ErasePrPlot)
    switch  ErasePrPlot
        case 'YES'
            LISTH = {'hplot','hplotLABN','hplotLABN2','hplotLLL','hplotSURF','hplotl','hplotp','hplotgraph','hplotquiver'};
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
    end
end



    switch  ErasePrPlot_path
        case 'YES'
            LISTH = {'hplotp','hplotquiver','hplotl'};
            strcom = {};
            for ilist = 1:length(LISTH)
                hplotlocal = LISTH{ilist} ;
                switch ErasePrPlot_path
                    case 'YES'
                        strl = ['for ih = 1:length(',hplotlocal,');',[' if ishandle(',hplotlocal,'(ih)) & ',hplotlocal,'(ih) ~=0 ;delete(',hplotlocal,'(ih))  ;        end;'],'      end'] ;
                    otherwise
                        strl = '' ;
                end
                eval([ 'if isfield(DATA,','''',hplotlocal,''') ; ',hplotlocal,' = DATA.',hplotlocal,';',strl,'; end ;']);
                %eval(['for ih = 1:length(',hplotlocal,');',[' if ishandle(',hplotlocal,'(ih)) & ',hplotlocal,'(ih) ~=0 ;delete(',hplotlocal,'(ih))  ;        end;'],'      end']);
                eval([hplotlocal,'= 0;'])
            end
    end




if ~strcmp(axiskindBEF,axiskind)
    switch axiskind
        case 'NON-AUTO'
            [X_min,X_max,Y_min,Y_max] = ...
                MenuMake('Axes limits','on',[pathdata,'showoopt1.mat'] ,0, ...
                'X_min',[1 12],'-100.0',0,0,{},0,...
                'X_max',[1 12],'40.0',0,0,{},0,...
                'Y_min',[1 12],'0.0',0,0,{},0,...
                'Y_max',[1 12],'80',0,0,{},0);
            axislim = [X_min,X_max,Y_min,Y_max] ;
        case 'CURRENT'
            axislim = axis ;
            SaveAns{1} = axislim(1) ;
            SaveAns{2} = axislim(2) ;
            SaveAns{3} = axislim(3) ;
            SaveAns{4} = axislim(4) ;
            save([pathdata,'showoopt1.mat'],'SaveAns') ;
            load([pathdata,'showoopt.mat'],'SaveAns') ;
            SaveAns{2} = 2 ;
            save([pathdata,'showoopt.mat'],'SaveAns') ;
            axiskind = 'NON-AUTO' ;
            
    end
end

if  strcmp(shownumber,'NO')
    LISTH = {'hplotLABN','hplotLABN2'};
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
    
end





%***********************************
% Storing all variables in DATA
%***********************************
for ivar = 1:length(VARIABLES) ;
    num_var = VARIABLES{ivar};
    eval(['DATA.VAR.',num_var,' = ',num_var,';']);
end


guidata(gcf,DATA)
%save(DATA.NameWs,'-append');
save(DATA.NameWs);

CALLBACK_main ;
