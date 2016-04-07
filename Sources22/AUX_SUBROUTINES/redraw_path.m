function redraw_path
% See draw_path.m
% Callback function for drawing path stress
% -----------------------------------------

% ************************
%1) Extract DATA from gcf
% ************************
DATA = guidata(gcf);
load(DATA.NameWs);

if strcmp(splitwind,'YES')
    subplot(2,1,1);
end
hold on

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


%  Editboxes (VARIABLES_LEG2),
% **********************************************************
fhandle = guihandles(gcf) ; % --> Tag
VARIABLES_LEG2 = DATA.VARIABLES_LEG2 ;
for ivar = 1:length(VARIABLES_LEG2)
    hread = getfield(fhandle,VARIABLES_LEG2{ivar});
    STRE = [VARIABLES_LEG2{ivar},' = str2num(get(hread,''String''));'];
    eval(STRE);
end



LISTH = {'hplotLABN','hplotLABN2','hplotLLL','hplotSURF','hplotp','hplotl','hplotgraph'};
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



% RE-DRAW
istep = [istep1 istep2 istep3] ;
[ hplotp hplotl]=plotpath(SIGMAP,hplotp,nnls_s,istep,hplotl);
% STRAINS 
[strain] = calstrain(istep,mstrain,STRAIN) ;

DATA.hplotp = hplotp  ;
DATA.hplotl = hplotl  ;
DATA.strain = strain  ; 


%%%%%

%***********************************
% Storing all variables in DATA
%***********************************
for ivar = 1:length(VARIABLES) ;
    num_var = VARIABLES{ivar};
    eval(['DATA.VAR.',num_var,' = ',num_var,';']);
end









guidata(gcf,DATA)
save(DATA.NameWs,'-append');
