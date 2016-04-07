function compute_load
global hplotSURF
%profile on 
% See main.m
% Callback function for computing sigma = f(strain)

% ************************
%1) Extract DATA from gcf
% ************************
%dbstop('11')
DATA = guidata(gcf);
try
load(DATA.NameWs);
catch 
    error('MAKE SURE CURRENT DIRECTORY CONTAINS main.m')
end

% For plotting
% ************
ncolores = 3 ;
colores =  ColoresMatrix(ncolores);
markers = MarkerMatrix(ncolores) ;

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


% PLOTTING (PATH)
% ********
% Divide SIGMAP{end} - SIGMAP{end-1} in istep1 steps
istep = [istep1 istep2 istep3] ;
try 
[ hplotp hplotl]=plotpath(SIGMAP,hplotp,nnls_s,istep,hplotl);
catch
    error('ERROR: Select load path ')
end

DATA.hplotp = hplotp  ;
DATA.hplotl = hplotl  ;
% ------------
% INITIALIZING
% ------------
% For storing cauchy stress and others
% % ************************************
% sigma_v = cell(sum(istep)+1,1) ;
% hvar_n_v = cell(sum(istep)+1,1) ;



LISTH = {'hplots','hplotLABN','hplotSURF','hplotLLL','hplotquiver'};
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


hplots = 0 ;
hplotLABN = 0 ;
hplotSURF = 0 ;
hplotLLL  = 0 ;
%%%%%%%%%%%%%%

switch axiskind
    case 'NON-AUTO'
        axis(axislim);
    otherwise
        axis auto
end


% VARIABLES = {'YOUNG_M','POISSON','HARDSOFT_MOD','YIELD_STRESS','ntype_c', ...
%     'nnls_s','istep1','istep2','istep3','n','MDtype_c','mstrain', ...
%     'mhist','shownumber','axiskind','axislim','ErasePrPlot','vpx','vpy','splitwind','pathdata', ...
%     'HARDTYPE','VISCOUS','eta','TimeTotal','alpha'} ;

%% Changing names 
% --------------- 
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






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%delta_t = TimeTotal./istep/3 ;

Eprop   = [E nu HARDSOFT_MOD sigma_u hard_type viscpr eta ALPHA_COEFF]             ;


% ------------
% DAMAGE MODEL
% ------------ 
[sigma_v,vartoplot,LABELPLOT,TIMEVECTOR]=damage_main(Eprop,ntype,istep,strain,MDtype,n,TimeTotal);


% -------------------------------------------------------------------------


% 
% [ce]    = tensor_elastico1 (Eprop, ntype);
% eps_n1  = zeros(mstrain,1);
% hvar_n  = zeros(mhist,1);
% for i = 1:istep1+istep2++istep3+1
% 
%     % Total strain at step "i"
%     % ------------------------
%     eps_n1 = strain(i,:) ;
% 
%     %**************************************************************************************
%     %*      DAMAGE MODEL
%     % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%     [sigma_n1,hvar_n,aux_var] = rmap_dano1 (eps_n1,hvar_n,Eprop,ce,MDtype,n);
%     % PLOTTING DAMAGE SURFACE
%     if(aux_var(1)>0)
%         hplotSURF(i) = dibujar_criterio_dano1(ce, nu, hvar_n(6), 'r:',MDtype,n );
%         set(hplotSURF(i),'Color',[0 0 1],'LineWidth',1);
%     end
%     
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     %**********************************************************************
%       % GLOBAL VARIABLES 
%     % ***************
%     m_sigma=[sigma_n1(1)  sigma_n1(3) 0;sigma_n1(3) sigma_n1(2) 0 ; 0 0  sigma_n1(4)];     
%     sigma_v{i} =  m_sigma ;
%     hvar_n_v{i} =  hvar_n ;
%     %aux_var_v{i} = aux_var ;
% end
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%






% PLOTTING
% -------

% PLOTTING
% --------

% LABEL
% -----
if strcmp(shownumber,'YES')
    % strt = ['''\leftarrow N ='',','num2str(i)'];
        strt = [''' N ='',','num2str(i)'];
    string_1 = ['hplotLABN(end+1) = text(sigma_v{i}(1,1),sigma_v{i}(2,2),[',strt,'],''Color'',colores(1,:));'] ;
    string_2 = ['hplotLABN(end+1) = text(sigma_v{i}(1,1),sigma_v{i}(2,2),[',strt,'],''Color'',colores(2,:));'] ;
    string_3 = ['hplotLABN(end+1) = text(sigma_v{i}(1,1),sigma_v{i}(2,2),[',strt,'],''Color'',colores(3,:));'] ;
else
    string_1 = '' ;     string_2 = '' ;     string_3 = '' ;
end

for i = 2:istep1+1
    stress_eig  = sigma_v{i} ; %eigs(sigma_v{i}) ;
    tstress_eig = sigma_v{i-1}; %eigs(sigma_v{i-1}) ;
    hplotLLL(end+1) = plot([tstress_eig(1,1) stress_eig(1,1) ],[tstress_eig(2,2) stress_eig(2,2)],'LineWidth',2,'color',colores(1,:),'Marker',markers{1},'MarkerSize',2);
    eval(string_1);
    % SURFACES
    % -----
    
end
for i = istep1+2:istep1+istep2+1
    stress_eig = (sigma_v{i}) ;
    tstress_eig = (sigma_v{i-1}) ;
    hplotLLL(end+1) = plot([tstress_eig(1,1) stress_eig(1,1) ],[tstress_eig(2,2) stress_eig(2,2)],'LineWidth',2,'color',colores(2,:),'Marker',markers{2},'MarkerSize',2);
    eval(string_2);
  
end
for i = istep1+istep2+2:istep1+istep2+istep3+1
    stress_eig = (sigma_v{i}) ;
    tstress_eig = (sigma_v{i-1}) ;
    hplotLLL(end+1) = plot([tstress_eig(1,1) stress_eig(1,1) ],[tstress_eig(2,2) stress_eig(2,2)],'LineWidth',2,'color',colores(3,:),'Marker',markers{3},'MarkerSize',2);
    eval(string_3);

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

% Modify wplotx/y
% ------------- 
wplotx = cat(2,wplotx0,LABELPLOT);
wploty = cat(2,wploty0,LABELPLOT);




for ilist = 1:length(LISTH)
    hplotlocal = LISTH{ilist} ;
    eval(['DATA.',hplotlocal,' = ',hplotlocal,';']) ;
end




%***********************************
% Storing all variables in DATA
%***********************************
for ivar = 1:length(VARIABLES) ;
    num_var = VARIABLES{ivar};
    eval(['DATA.VAR.',num_var,' = ',num_var,';']);
end








guidata(gcf,DATA)
save(DATA.NameWs);

%save(DATA.NameWs,'-append');
%save(DATA.NameWs,'DATA','YOUNG_M','POISSON','HARDSOFT_MOD','YIELD_STRESS','ntype_c','istep1','istep2','istep3',...
%    'n','MDtype_c','NameWs','HARDTYPE','VISCOUS','eta','TimeTotal','ALPHA_COEFF');

plotcurves ;

%profile report 
