clc
clear all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Program for modelling damage model
% (Elemental gauss point level)
% GRAPHIC INTERFACE
% -----------------
% Developed by J.Hdez Ortega
% 20-May-2007, Universidad Politécnica de Cataluña
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%profile on

                   % ------------------------


current_dir = cd ;
if isunix
    if exist('CALLBACK_main.m') == 2
    else
        addpath([current_dir,'/AUX_SUBROUTINES']);
        % addpath(current_dir);
    end
    
    if exist('damage_main.m') == 2
    else
        addpath([current_dir]);
        % addpath(current_dir);
    end
    
    pathdata = [current_dir,'/AUX_SUBROUTINES/WSFILES/'];
    
else
    if exist('CALLBACK_main.m') == 2
    else
        addpath([current_dir,'\AUX_SUBROUTINES']);
    end
     if exist('damage_main.m') == 2
    else
        addpath([current_dir]);
        % addpath(current_dir);
    end
    % addpath(current_dir);
    pathdata = [current_dir,'\AUX_SUBROUTINES\WSFILES\'];
end

if exist(pathdata,'dir') == 0
    mkdir('\AUX_SUBROUTINES\WSFILES\') ;
end


% ****************
% INPUTS
% ****************
% -----------------------------
% OTHER INPUTS (Graphic Inputs)
% -----------------------------
Inc      = [0 -0.040 0 0] ;
NameFileExec = 'CALLBACK_main';
NameFileExecP = 'redraw_path';
Position = [0.01 0.9500 0.08 0.030] ;
PTC = {'SYMMETRIC','ONLY TENSION','NON-SYMMETRIC'};
TP = {'PLANE STRESS','PLANE STRAIN','3D'} ;
ce = 0 ;
nnls_s    = 3 ; % Number of load states
mstrain = 4 ;  % Number of components of strain vector
mhist   = 6 ; % Number of componets of historical variables vector
shownumber = 'YES'     ;
axiskind   = 'NON-AUTO'   ;
axislim    = [-500 500 -500 500] ;
ErasePrPlot = 'YES' ;
wplotx      ={'STRAIN_1','STRAIN_2','|STRAIN_1|','|STRAIN_2|','norm(STRAIN)','TIME'};
vpx         = 'STRAIN_1' ;
wploty      ={'STRESS_1','STRESS_2','|STRESS_1|','|STRESS_2|','norm(STRESS)'};
vpy         = 'STRESS_1' ;
splitwind   = 'YES' ;
HARDLIST    = {'LINEAR','EXPONENTIAL'} ;
% Inc      = [0 -0.040 0 0] ;
% ---------------------------------------
%Set of variables (to be stored in DATA)
% ----------------------------------------

%  Workspace name
NameWs = [pathdata,'tmp1_maing.mat'];
%%%%% MODEL INPUTS ( as uicontrols)
wplotx0 = wplotx;wploty0 = wploty;


    COMPTA = 0 ; 

if exist(NameWs) == 2
    try 
    load(NameWs);
catch
    COMPTA = 1 ; 
end

else
    COMPTA = 1 ; 
end
    
    
if  COMPTA == 1   

    % YOUNG's MODULUS
    % ---------------
    YOUNG_M = 20000 ;
    % Poisson's coefficient
    % -----------------------
    POISSON = 0.3 ;
    % Hardening/softening modulus
    % ---------------------------
    HARDSOFT_MOD = -0.1 ;
    % Yield stress
    % ------------
    YIELD_STRESS = 200 ;
    % Problem type  TP = {'PLANE STRESS','PLANE STRAIN','3D'}
    % ------------
    ntype_c = 'PLANE STRAIN' ;

    % Number of increments of each load state
    % ---------------------------------------
    istep1 = 5 ;
    istep2 = 6 ;
    istep3 = 5 ;
    % Ratio compression strength / tension strength
    % ---------------------------------------------
    n = 3 ;
    % Model    PTC = {'SYMMETRIC','TRACTION','NON-SYMMETRIC'} ;
    % ---------------------------------------------------
    MDtype_c = 'SYMMETRIC' ;
    try
        save(NameWs) ;
    catch
        error('PATTERN PATH INCORRECT: Make sure that the currect directory contains file main.m')
    end
    % SOFTENING/HARDENING TYPE
    % ------------------------
    HARDTYPE = 'LINEAR' ; %{LINEAR,EXPONENTIAL}
    % VISCOUS/INVISCID
    % ------------------------
    VISCOUS = 'NO' ;
    % Viscous coefficient ----
    % ------------------------
    eta = 0.3 ;
    % TimeTotal (initial = 0) ----
    % ------------------------
    TimeTotal = 10 ; ;
    % Integration coefficient ALPHA
    % ------------------------
    ALPHA_COEFF = 0.5 ;
end



VARIABLES = {'YOUNG_M','POISSON','HARDSOFT_MOD','YIELD_STRESS','ntype_c', ...
    'nnls_s','istep1','istep2','istep3','n','MDtype_c','mstrain', ...
    'mhist','shownumber','axiskind','axislim','ErasePrPlot','vpx','vpy','splitwind','pathdata', ...
    'HARDTYPE','VISCOUS','eta','TimeTotal','ALPHA_COEFF','wplotx','wploty'} ;

% **********
% UICONTROLS
% **********

clf;figure(1);clf;
hold on
grid on
xlabel('\sigma_1');
ylabel('\sigma_2');
%-----------------------------------------------
%  Edit boxes  (-->VARIABLES_LEG), at the LEFT
%-----------------------------------------------
VARIABLES_LEG = {'YOUNG_M','POISSON','HARDSOFT_MOD','YIELD_STRESS'};
VARIABLES_TEXT = {'YOUNG_M','POISSON','HARDSOFT_MOD','YIELD_STRESS'};
Inc_tv     = 0.002  ;
Inc_vt     = 0.002 ;
PositionT0 = [0.01 0.925 0.079 0.015  ] ;
PositionV0 = [0.01 0.9 0.079 0.023  ] ;
inclt = [ 0 PositionT0(4) + PositionV0(4) + Inc_tv + Inc_vt 0 0] ;
inclv = [0 PositionT0(4) + PositionV0(4) + Inc_vt + Inc_vt 0 0] ;
for ileg = 1:length(VARIABLES_LEG) ;
    var_i = VARIABLES_LEG{ileg} ;     text_i = VARIABLES_TEXT{ileg} ;
    if ~isempty(num2str(eval(var_i))); var_inum = num2str(eval(var_i));  else;  var_inum = eval(var_i) ;   end
    PositionT = PositionT0 -  (ileg-1)*inclt;
    STRE = ['htext = uicontrol(''Style'',''text'',''Units'',''normalized'',''Position'',PositionT'',''FontWeight'',''Bold'',''FontSize'',9,''string'',''',text_i,''');'] ;
    eval(STRE);
    PositionV = PositionV0 -  (ileg-1)*inclv;
    STRE =['hp',num2str(ileg),' = uicontrol(''Style'',''edit'',''String'',var_inum,''Units'',''normalized'',''Position'',PositionV'',''FontSize'',9,''Tag'',''',var_i,''', ''Callback'',NameFileExec);'];
    eval(STRE);
end

% %%%%%%%%%%%%%%%%%%%%%%
% 2) MDtype_c
% %%%%%%%%%%%%%%%%%%%%%%
[ok MDtype] = FndStrInCell(PTC,MDtype_c) ;
fff =uicontrol('Style', 'text', 'String', 'Damage model',...
    'Units','normalized','Position', [0.768 0.974 0.18 0.02],'FontSize',10,'FontWeight','Bold');
fff =uicontrol('Style', 'popupmenu', 'String', PTC,...
    'Units','normalized','Position', [0.768 0.917 0.18 0.057],'Callback',NameFileExec,...
    'Tag','MDtype','Value',MDtype);

% %%%%%%%%%%%%%%%%%%%%%%
% 3) PROBLEM TYPE --> TP
% %%%%%%%%%%%%%%%%%%%%%%
[ok ntype] = FndStrInCell(TP,ntype_c) ;
fff =uicontrol('Style', 'text', 'String', 'Problem type',...
    'Units','normalized','Position', [0.568 0.974 0.18 0.02],'FontSize',10,'FontWeight','Bold');
fff =uicontrol('Style', 'popupmenu', 'String', TP,...
    'Units','normalized','Position', [0.568 0.917 0.18 0.057],'Callback',NameFileExec,...
    'Tag','ntype_c','Value',ntype);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 4) Ratio compression/traction strength
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fff =uicontrol('Style', 'text', 'String', {'ONLY FOR ','NON-SYMMETRIC','----------'},...
    'Units','normalized','Position',[0.01 0.472 0.08 0.050],'FontSize',9,'FontWeight','Bold');
fff =uicontrol('Style', 'text', 'String', 'ratio comp/trac',...
    'Units','normalized','Position',[0.01 0.442 0.08 0.02],'FontWeight','Bold','FontSize',9);
fff =uicontrol('Style', 'edit', 'String', num2str(n),...
    'Units','normalized','Position',[0.01 0.418 0.08 0.02],'FontSize',9,'tag','n',...
    'Callback',NameFileExec);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 5) INCREMENTS FOR EACH LOAD STATE
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fff =uicontrol('Style', 'text', 'String', {'INCREMENTS','----------'},...
    'Units','normalized','Position',[0.913 0.893 0.08 0.030],'FontSize',9,'FontWeight','Bold');
VARIABLES_LEG2 = {'istep1','istep2','istep3'};
Position = [0.913 0.893 0.08 0.025] ;
Inc      = [0 -0.030 0 0] ;

for ileg = 1:length(VARIABLES_LEG2)
    var_i = VARIABLES_LEG2{ileg} ;
    var_inum = num2str(eval(var_i));
    Position = Position + Inc ;
    STRE = ['htext = uicontrol(''Style'',''text'',''Units'',''normalized'',''Position'',Position,''FontSize'',9,''string'',''',var_i,''');'] ;
    eval(STRE);
    Position = Position + Inc ;
    STRE =['hp',num2str(ileg),' = uicontrol(''Style'',''edit'',''String'',var_inum,''Units'',''normalized'',''Position'',Position,''FontSize'',9,''Tag'',''',var_i,''', ''Callback'',NameFileExecP);'];
    eval(STRE);
end

% ----------------------------------------------
% Pushbottoms
% ----------------------------------------------
hpushsel1 = uicontrol('Style','pushbutton',...
    'String',{'SELECT LOAD PATH'},'Units','normalized','Position',[0.00703125 0.119 0.11015 0.0336],'Callback','select_path', ...
    'tag','select_load');

hpushsel1 = uicontrol('Style','pushbutton',...
    'String',{'COMPUTE'},'Units','normalized','Position',[0.00703125 0.065 0.11015 0.044],'Callback','compute_load', ...
    'tag','c');

hpushsel1 = uicontrol('Style','pushbutton',...
    'String',{'REFRESH'},'Units','normalized','Position',[0.00703125 0.022 0.11015 0.03687],'Callback','refresh_main', ...
    'tag','c');

hpushsel1 = uicontrol('Style','pushbutton',...
    'String',{'OPTIONS'},'Units','normalized','Position',[0.1 0.94 0.08 0.05],'Callback','showoptions', ...
    'tag','showoptions2');


% %%%%%%%%%%%%%%%%%%%%%%
% *) PLOT X
% %%%%%%%%%%%%%%%%%%%%%%
[ok nvx] = FndStrInCell(wplotx,vpx) ;
fff =uicontrol('Style', 'text', 'String', 'VAR X',...
    'Units','normalized','Position', [0.2 0.974 0.14 0.02],'FontSize',10,'FontWeight','Bold');
fff =uicontrol('Style', 'popupmenu', 'String', wplotx,...
    'Units','normalized','Position', [0.2 0.917 0.14 0.057],'Callback','plotcurves',...
    'Tag','xplotc','Value',nvx);
% %%%%%%%%%%%%%%%%%%%%%%
% *) PLOT Y
% %%%%%%%%%%%%%%%%%%%%%%
[ok nvy] = FndStrInCell(wploty,vpy) ;
fff =uicontrol('Style', 'text', 'String', 'VAR Y',...
    'Units','normalized','Position', [0.36 0.974 0.14 0.02],'FontSize',10,'FontWeight','Bold');
fff =uicontrol('Style', 'popupmenu', 'String', wploty,...
    'Units','normalized','Position', [0.36 0.917 0.14 0.057],'Callback','plotcurves',...
    'Tag','yplotc','Value',nvy);

%%%% HARDTYPE
[ok ntype] = FndStrInCell(HARDLIST,HARDTYPE) ;
fff =uicontrol('Style', 'text', 'String', 'HARD/SOFT EV.',...
    'Units','normalized','Position',[0.01 0.745 0.079 0.015] ,'FontSize',9,'FontWeight','Bold');
fff =uicontrol('Style', 'popupmenu', 'String', HARDLIST,...
    'Units','normalized','Position',[0.01 0.7150 0.077 0.023] ,'Callback',NameFileExec,...
    'Tag','HARDTYPE_tag','Value',ntype,'FontSize',8);

%%%% VISCOUS
[ok ntype] = FndStrInCell({'YES','NO'},VISCOUS) ;
fff =uicontrol('Style', 'text', 'String', 'VISCOUS MODEL',...
    'Units','normalized','Position',[0.01 0.696 0.079 0.015] ,'FontSize',9,'FontWeight','Bold');
fff =uicontrol('Style', 'popupmenu', 'String',{'YES','NO'} ,...
    'Units','normalized','Position',[0.01 0.666 0.077 0.023] ,'Callback',NameFileExec,...
    'Tag','VISCOUS_tag','Value',ntype,'FontSize',8);

%%%%%%%%%%%%%%%%%%%%%%%%%%

%-----------------------------------------------
%  Edit boxes  OTHER PARAMETERS
%-----------------------------------------------
VARIABLES_LEG3 = {'eta','TimeTotal','ALPHA_COEFF'};
VARIABLES_TEXT = {'viscous coeff.','TIME INT.(s)','ALPHA coeff.'};
Inc_tv     = 0.002  ;
Inc_vt     = 0.002 ;
PositionT0 = [0.01 0.638 0.079 0.015  ] ;
PositionV0 = [0.01 0.613 0.079 0.023  ] ;
inclt = [ 0 PositionT0(4) + PositionV0(4) + Inc_tv + Inc_vt 0 0] ;
inclv = [0 PositionT0(4) + PositionV0(4) + Inc_vt + Inc_vt 0 0] ;
for ileg = 1:length(VARIABLES_LEG3) ;
    var_i = VARIABLES_LEG3{ileg} ;     text_i = VARIABLES_TEXT{ileg} ;
    if ~isempty(num2str(eval(var_i))); var_inum = num2str(eval(var_i));  else;  var_inum = eval(var_i) ;   end
    PositionT = PositionT0 -  (ileg-1)*inclt;
    STRE = ['htext = uicontrol(''Style'',''text'',''Units'',''normalized'',''Position'',PositionT'',''FontWeight'',''Bold'',''FontSize'',9,''string'',''',text_i,''');'] ;
    eval(STRE);
    PositionV = PositionV0 -  (ileg-1)*inclv;
    STRE =['hp',num2str(ileg),' = uicontrol(''Style'',''edit'',''String'',var_inum,''Units'',''normalized'',''Position'',PositionV'',''FontSize'',9,''Tag'',''',var_i,''', ''Callback'',NameFileExec);'];
    eval(STRE);
end



%***********************************
% Storing all variables in DATA
%***********************************
for ivar = 1:length(VARIABLES) ;
    num_var = VARIABLES{ivar};
    eval(['DATA.VAR.',num_var,' = ',num_var,';']);
end
DATA.VARIABLES_LEG = VARIABLES_LEG ;
DATA.VARIABLES_LEG2 = VARIABLES_LEG2 ;
DATA.VARIABLES_LEG3 = VARIABLES_LEG3 ;
DATA.NameWs        = NameWs        ;
DATA.wplotx0 = wplotx0 ;
DATA.wploty0 = wploty0 ;

%----------------------------------
% Attach DATA to the current figure
%----------------------------------
guidata(gcf,DATA);
CALLBACK_main    ;


%profile report
