function selec_path
% Selecting stress path
% ---------------------
%profile on 
% ************************
%1) Extract DATA from gcf
% ************************
DATA = guidata(gcf);
try
load(DATA.NameWs);
end

if strcmp(splitwind,'YES')
    subplot(2,1,1);
end
hold on
xlabel('\sigma_1') ;
ylabel('\sigma_2') ;

%2) Defining variables (local names)
%   like alfa_03 = getfield(DATA.VAR.alfa_03)
%---------------------------------------------
VARIABLES = fieldnames((DATA.VAR)) ;
for ivar = 1:length(VARIABLES)
    STRE = [VARIABLES{ivar},' = getfield(DATA.VAR,VARIABLES{ivar});' ];
    eval(STRE) ;
end


Eprop=[YOUNG_M POISSON HARDSOFT_MOD YIELD_STRESS];
sigma_u =YIELD_STRESS ;
E = YOUNG_M ;
nu = POISSON ;

switch ntype_c
    case 'PLANE STRAIN'
        
        [ce] = tensor_elastico1 (Eprop, ntype);
        % POLINOMIAL PATH
        % ***************
        % (3 steps)
        SIGMAP = cell(1,nnls_s+1) ;
        SIGMAP{1} = zeros(1,4)  ;
        STRAIN = cell(1,nnls_s+1) ;
        STRAIN{1} =  zeros(1,4)  ;
        
        % ERASE
        % *****
        LISTH = {'hplots','hplotLABN','hplotSURF','hplotLLL','hplotp','hplotl','hplotquiver'};
        strcom = {};
        for ilist = 1:length(LISTH)
            hplotlocal = LISTH{ilist} ;
            switch ErasePrPlot
                case 'YES'
                    strl = ['for ih = 1:length(',hplotlocal,');',[' if ishandle(',hplotlocal,'(ih)) & ',hplotlocal,'(ih) ~=0 ;delete(',hplotlocal,'(ih))  ;        end;'],'      end'] ;
                otherwise
                    strl = '' ;
            end
            strl = ['for ih = 1:length(',hplotlocal,');',[' if ishandle(',hplotlocal,'(ih)) & ',hplotlocal,'(ih) ~=0 ;delete(',hplotlocal,'(ih))  ;        end;'],'      end'] ;
            eval([ 'if isfield(DATA,','''',hplotlocal,''') ; ',hplotlocal,' = DATA.',hplotlocal,';',strl,';end ;']);
            %            eval(['for ih = 1:length(',hplotlocal,');',[' if ishandle(',hplotlocal,'(ih)) & ',hplotlocal,'(ih) ~=0 ;delete(',hplotlocal,'(ih))  ;        end;'],'      end']);
            eval([hplotlocal,'= 0;'])
        end
        
        
        %%%%  STRETCHES
        %%%%%%%%%%%%%%%%%%
        %         LABELT = {'DEFINE FIRST STRECHT (FIRST POINT = [0 0])';
        %             'DEFINE SECOND STRECHT';
        %             'DEFINE THIRD STRECHT'};
        LABELT = {'DEFINE FIRST STRESS INCREMENT (FIRST POINT = [0 0])';
            'DEFINE SECOND STRESS INCREMENT';
            'DEFINE  THIRD STRESS INCREMENT'};
        istep = [istep1,istep2,istep3] ;
        
        aold = [0  0 ] ;
        
        
        for iloc = 1:nnls_s
            choice = menu(LABELT{iloc},'GRAPHIC SELECTION','BASE');
            if choice == 1
                [a]=ginput(1);
                SaveAns{1} = num2str(a(1));
                SaveAns{2} = num2str(a(2));
                save([pathdata,'tmpsp',num2str(iloc),'.mat'],'SaveAns');
            else
                [inca1 inca2] = ...
                    MenuMake(['STRESS INCREMENT COORDINATES (',num2str(iloc),')'],'on',[pathdata,'tmpsp',num2str(iloc),'.mat'] ,0, ...
                    'INCREMENT SIGMA 1 = ',[1 10],'1.0',0,0,[1],0,...
                    'INCREMENT SIGMA 2 = ',[1 10],'1.0',0,0,[1],0);
                a(1) = aold(1)+inca1 ; a(2) = aold(2)+inca2 ;
            end
            % We assume we are in the elastic range, thus sigma_33 = poisson*(sigma_11+sigma_22)
            sigma_0=[a(1) a(2) 0  nu*(a(1)+a(2))];
            aold = a ; 
            % iloc-th point of the path is stored in SIGMAP ;
            SIGMAP{iloc+1} =  sigma_0 ;
            sigma_bef = SIGMAP{iloc} ;
            stress_incre = sigma_0 - sigma_bef ;
            % Plot stress increment vector
            % ****************************
%  %           if exist('quiver.m') > 0
%                 if isunix
%                     hplotquiver(end+1) = quiver(sigma_bef(1),sigma_bef(2),stress_incre(1),stress_incre(2),0) ;
%                     set(hplotquiver(end),'LineWidth',1)
%                 else
%                     [aaa ] = quiver(sigma_bef(1),sigma_bef(2),stress_incre(1),stress_incre(2),0) ;
%                      hplotquiver(end+1:end+2) = aaa ;
%                 end
%                 
%             else
                hplotquiver(end+1) = plot([sigma_bef(1) sigma_0(1)],[sigma_bef(2) sigma_0(2)]) ;
                %end
            
            % Strain
            % ----------------
            strain_di =(inv(ce)*sigma_0')';
            STRAIN{iloc+1} = strain_di ;
            
        end
        
        
        % Plot iloc-th stretch
        % --------------------
        [ hplotp hplotl]=plotpath(SIGMAP,hplotp,nnls_s,istep,hplotl);   
        
        %%% STRAIN EVOLUTION
        %%%%%%%%%%%%%%%%%%%%        
        [strain] = calstrain(istep,mstrain,STRAIN) ;
end


switch axiskind
    case 'NON-AUTO'
        axis(axislim);
    otherwise
        axis auto
end
% OUTPUTS
% -------
DATA.hplotp = hplotp ;
DATA.hplotl = hplotl ;
DATA.hplotquiver = hplotquiver ;
DATA.strain = strain ;
DATA.LABELT = LABELT ;
DATA.SIGMAP = SIGMAP ;
DATA.STRAIN = STRAIN  ; 
%DATA.istep  = istep  ;

guidata(gcf,DATA)


save(DATA.NameWs);

%save(DATA.NameWs,'DATA','-append');

%profile off
