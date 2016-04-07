function CALLBACK_main
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Callback --> See main.m
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ************************
%1) Extract DATA from gcf
% ************************
%dbstop('10')
DATA = guidata(1);

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

%4) Read inputs from graphic (uicontrols)
%   -------------------------------------
%  A) editboxes (VARIABLES_LEG), at the left
% **********************************************************
fhandle = guihandles(gcf) ; % --> Tag
VARIABLES_LEG = DATA.VARIABLES_LEG ;
for ivar = 1:length(VARIABLES_LEG)
    hread = getfield(fhandle,VARIABLES_LEG{ivar});
    STRE = [VARIABLES_LEG{ivar},' = str2num(get(hread,''String''));'];
    eval(STRE);
end
% %%%%%%%%%%%%%%%%%%%%%%
% 2) MDtype_c
% %%%%%%%%%%%%%%%%%%%%%%
hread = getfield(fhandle,'MDtype');
String = get(hread,'String')      ;
MDtype  = get(hread,'Value')       ;
MDtype_c = String{MDtype} ;
% %%%%%%%%%%%%%%%%%%%%%%
% 3) ntype_c
% %%%%%%%%%%%%%%%%%%%%%%
hread = getfield(fhandle,'ntype_c');
String = get(hread,'String')      ;
ntype  = get(hread,'Value')       ;
ntype_c = String{ntype} ;
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 4) Ratio compression/traction strength
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hread = getfield(fhandle,'n');
String = get(hread,'String')      ;
n = str2num(String) ;
% %%%%%%%%%%%%%%%%%%%%%%
% *) HARDTYPE
% %%%%%%%%%%%%%%%%%%%%%%
hread = getfield(fhandle,'HARDTYPE_tag');
String = get(hread,'String')      ;
nnn  = get(hread,'Value')       ;
HARDTYPE = String{nnn} ;
% %%%%%%%%%%%%%%%%%%%%%%
% *) VISCOUS
% %%%%%%%%%%%%%%%%%%%%%%
hread = getfield(fhandle,'VISCOUS_tag');
String = get(hread,'String')      ;
nnn  = get(hread,'Value')       ;
VISCOUS = String{nnn} ;
%   -------------------------------------
%  A) editboxes (VARIABLES_LEG3), at the left
% **********************************************************
fhandle = guihandles(gcf) ; % --> Tag
VARIABLES_LEG3 = DATA.VARIABLES_LEG3 ;
for ivar = 1:length(VARIABLES_LEG3)
    hread = getfield(fhandle,VARIABLES_LEG3{ivar});
    STRE = [VARIABLES_LEG3{ivar},' = str2num(get(hread,''String''));'];
    eval(STRE);
end
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              COMPUTING AND PLOTING                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%**************************************************************************************
%*      Inicializaci�n de variables y puestas en ceros
%%*
if ntype == 1
    menu('PLANE STRESS has not been yet implemented','STOP');
    error('OPTION NOT AVAILABLE')
elseif ntype == 3
    menu('3-DIMENSIONAL PROBLEM has not been yet implemented','STOP');
    error('OPTION NOT AVAILABLE')
else
    mstrain = 4    ;
    mhist   = 6    ;
end


%**************************************************************************************
Eprop=[YOUNG_M POISSON HARDSOFT_MOD YIELD_STRESS];
sigma_u =YIELD_STRESS ;
E = YOUNG_M ;
nu = POISSON ;

%**************************************************************************************
%*      Evaluar el tensor constitutivo el�stico (Matriz de Hooke)                    %*
%*      Llamado de Rutina tensor_elastico1                                           %*
[ce] = tensor_elastico1 (Eprop, ntype);
%**************************************************************************************


%**************************************************************************************
%*      Dibujo de la superficie de da�o                                              %*
%*      Llamado de Rutina dibujar criterio_citerio_da�o1                             %*
figure(1);
set(1,'Name','ANALYSIS OF A DAMAGE MODEL (GAUSS POINT LEVEL)')
hold on;
%dbstop('122')
if strcmp(splitwind,'YES')
    subplot(2,1,1);
    title('Damage surface (principal stresses axes)')
     xlabel('\sigma_{1}')
     ylabel('\sigma_{2}')
end
hold on;
grid on;
q=sigma_u/sqrt(E);
switch ErasePrPlot
    case 'YES'
        if isfield(DATA,'hplot')
            if ishandle(DATA.hplot) & DATA.hplot ~= 0
                delete(DATA.hplot)
            end
        end
end
hplot = dibujar_criterio_dano1(ce, nu, q , 'b-',MDtype ,n );
DATA.hplot = hplot ;

%********************************
% Recomputing strains
%********************************
if isfield(DATA,'SIGMAP')
    [SIGMAP,STRAIN,strain]=recompstr(SIGMAP,nnls_s,nu,ce,STRAIN,mstrain,istep1, istep2, istep3);
    DATA.SIGMAP = SIGMAP ;
    DATA.STRAIN = STRAIN ;
    DATA.strain = strain ;
end


hold on
switch axiskind
    case 'NON-AUTO'
        axis(axislim);
    otherwise
        axis auto
        %axis equal
end





%***********************************
% Storing all variables in DATA
%***********************************
for ivar = 1:length(VARIABLES) ;
    num_var = VARIABLES{ivar};
    eval(['DATA.VAR.',num_var,' = ',num_var,';']);
end

% New ones ...
DATA.VAR.ntype = ntype;
DATA.VAR.MDtype = MDtype;

%dbstop('179')
guidata(gcf,DATA)
try
    save(DATA.NameWs);

    % save(DATA.NameWs,'-append');
    %save(DATA.NameWs,'DATA','YOUNG_M','POISSON','HARDSOFT_MOD','YIELD_STRESS','ntype_c','istep1','istep2','istep3',...
    %   'n','MDtype_c','NameWs','HARDTYPE','VISCOUS','eta','TimeTotal','ALPHA_COEFF');
catch
    if isunix
        % if exist('CALLBACK_main.m')
        % addpath([cd,'/AUX_SUBROUTINES']);
        % addpath(cd);
        pathdata = [cd,'/WSFILES/'];
        % end
    else
        %addpath([cd,'\AUX_SUBROUTINES']);
        pathdata = [cd,'\WSFILES\'];
    end

    try
    rmdir(pathdata,'s');
    end
    mkdir(pathdata) ;
    current_dir = cd ;
    cd(current_dir);
    run([cd,'/main.m'])

    %error('ERROR IN READING STORED DATA. RUN IT AGAIN')

end


%{'YOUNG_M','POISSON','HARDSOFT_MOD','YIELD_STRESS','ntype_c','istep1','istep2','istep3',...
%    'n','MDtype_c','NameWs','HARDTYPE','VISCOUS','eta','TimeTotal','ALPHA_COEFF'}
%

%
%
%     YOUNG_M = 20000 ;
%     % Poisson's coefficient
%     % -----------------------
%     POISSON = 0.3 ;
%     % Hardening/softening modulus
%     % ---------------------------
%     HARDSOFT_MOD = -0.1 ;
%     % Yield stress
%     % ------------
%     YIELD_STRESS = 200 ;
%     % Problem type  TP = {'PLANE STRESS','PLANE STRAIN','3D'}
%     % ------------
%     ntype_c = 'PLANE STRAIN' ;
%
%     % Number of increments of each load state
%     % ---------------------------------------
%     istep1 = 5 ;
%     istep2 = 6 ;
%     istep3 = 5 ;
%     % Ratio compression strength / tension strength
%     % ---------------------------------------------
%     n = 3 ;
%     % Model    PTC = {'SYMMETRIC','TRACTION','NON-SYMMETRIC'} ;
%     % ---------------------------------------------------
%     MDtype_c = 'SYMMETRIC' ;
%     try
%         save(NameWs) ;
%     catch
%         error('PATTERN PATH INCORRECT: Make sure that the currect directory contains file main.m')
%     end
%     % SOFTENING/HARDENING TYPE
%     % ------------------------
%     HARDTYPE = 'LINEAR' ; %{LINEAR,EXPONENTIAL}
%     % VISCOUS/INVISCID
%     % ------------------------
%     VISCOUS = 'NO' ;
%     % Viscous coefficient ----
%     % ------------------------
%     eta = 0.3 ;
%     % TimeTotal (initial = 0) ----
%     % ------------------------
%     TimeTotal = 10 ; ;
%     % Integration coefficient ALPHA
%     % ------------------------
%     ALPHA_COEFF = 0.5 ;
