clc;
%clear all;
%close all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Program for modelling damage model
% (Elemental gauss point level)
% -----------------
% Developed by J.A. Hdez Ortega
% 20-May-2007, Universidad Polit??cnica de Catalu??a
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%profile on

% ------------------------
% ****************
% INPUTS
% ****************

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
% ------------------------ = 1            =2         =3
% ------------
ntype= 2 ;
% Model    PTC = {'SYMMETRIC','TENSION','NON-SYMMETRIC'} ;
%                1    = 1         = 2         = 3
% ---------------------------------------------------
MDtype =1;
% Ratio compression strength / tension strength
% --------------------------------------------
n = 3 ;
% SOFTENING/HARDENING TYPE
% ------1-----------------
HARDTYPE = 'LINEAR' ; %{LINEAR,EXPONENTIAL}
% VISCOUS/INVISCID
% --------------------------
VISCOUS = 'YES' ;
% Viscous coefficient ----
% ------------------------
eta = 0.3;
% TimeTotal (initial = 0) ----
% ------------------------
TimeTotal = 20; 
% Integration coefficient ALPHA
% ------------------------
ALPHA_COEFF = 1 ;
% Points --------------------------
% ----------------------------------
nloadstates = 3 ;
SIGMAP = zeros(nloadstates,2) ;
SIGMAP(1,:) =[200 0];
SIGMAP(2,:) =[400 0];
SIGMAP(3,:) =[600 0];
% Number of time increments for each load state
% --------------------------------------- 
istep = 10*ones(1,nloadstates) ;
 
% VARIABLES TO PLOT
vpx ='TIME' ; % AVAILABLE OPTIONS: 'STRAIN_1', 'STRAIN_2'
%                    '|STRAIN_1|', '|STRAIN_2|'%'norm(STRAIN)'%
% 'norm(STRAIN)', 'TIME'
vpy = 'C11 algorithmic tangent'% 'norm(STRESS)'% 'internal variable (r)' %  'damage variable (d)'   %        % AVAILABLE OPTIONS: 'STRESS_1', 'STRESS_2'
%                    '|STRESS_1|', '|STRESS_2|'%
% 'norm(STRESS)', 'TIME', 'DAMAGE VAR.','hardening variable (q)','damage variable (d)'
  %'internal variable (r)'

%  3) LABELPLOT{ivar}              --> Cell array with the label string for
%                                    variables of "varplot"
%
LABELPLOT = {'hardening variable (q)','internal variable (r)','damage variable (d)'};

%%%%%%%%%%%%%%%%%%%55 END INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Plot Initial Damage Surface and effective stress path
strain_history = PlotIniSurf(YOUNG_M,POISSON,YIELD_STRESS,SIGMAP,ntype,MDtype,n,istep);



E       = YOUNG_M      ;
nu      = POISSON      ;
sigma_u = YIELD_STRESS ;



switch  HARDTYPE
    case 'LINEAR'
        hard_type = 0  ;
    otherwise
        hard_type = 1  ;
end
switch  VISCOUS
    case 'YES'
        viscpr = 1     ;
    otherwise
        viscpr = 0     ;
end


Eprop   = [E nu HARDSOFT_MOD sigma_u hard_type viscpr eta ALPHA_COEFF]             ;



% DAMAGE MODEL
% ------------
[sigma_v,ce_v,vartoplot,LABELPLOT_out,TIMEVECTOR]=damage_main(Eprop,ntype,istep,strain_history,MDtype,n,TimeTotal);



try LABELPLOT;catch;LABELPLOT = LABELPLOT_out ; end ;




% PLOTTING
% -------

ncolores = 3 ;
colores =  ColoresMatrix(ncolores);
markers = MarkerMatrix(ncolores) ;
hplotLLL = [] ;

for i = 2:length(sigma_v)
    stress_eig  = sigma_v{i} ; %eigs(sigma_v{i}) ;
    tstress_eig = sigma_v{i-1}; %eigs(sigma_v{i-1}) ;
    hplotLLL(end+1) = plot([tstress_eig(1,1) stress_eig(1,1) ],[tstress_eig(2,2) stress_eig(2,2)],'LineWidth',2,'color',colores(1,:),'Marker',markers{1},'MarkerSize',2);
    plot(stress_eig(1,1),stress_eig(2,2),'bx')
    text(stress_eig(1,1),stress_eig(2,2),num2str(i))
    
    
    % SURFACES
    % -----
    
end






% % SURFACES
% % -----
% if(aux_var(1)>0)
%     hplotSURF(i) = dibujar_criterio_dano1(ce, nu, hvar_n(6), 'r:',MDtype,n );
%     set(hplotSURF(i),'Color',[0 0 1],'LineWidth',1);
% end



DATA.sigma_v    = sigma_v     ;
DATA.vartoplot  = vartoplot   ;
DATA.LABELPLOT  = LABELPLOT   ;
DATA.TIMEVECTOR = TIMEVECTOR  ;
DATA.strain = strain_history ;
DATA.ce_v=ce_v;



plotcurvesNEW(DATA,vpx,vpy,LABELPLOT,vartoplot) ;



