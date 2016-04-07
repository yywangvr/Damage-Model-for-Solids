function strain =PlotIniSurf(YOUNG_M,POISSON,YIELD_STRESS,SIGMAP,ntype,MDtype,n,istep)


%**************************************************************************************

Eprop=[YOUNG_M POISSON 0 YIELD_STRESS];
sigma_u =YIELD_STRESS ;
E = YOUNG_M ;
nu = POISSON ;

%**************************************************************************************
%*      Evaluar el tensor constitutivo el???stico (Matriz de Hooke)                    %*
%*      Llamado de Rutina tensor_elastico1                                           %*
[ce] = tensor_elastico1 (Eprop, ntype);
%**************************************************************************************


%**************************************************************************************
%*      Dibujo de la superficie de da???o                                              %*
%*      Llamado de Rutina dibujar criterio_citerio_da???o1                             %*
figure(1);
set(1,'Name','ANALYSIS OF A DAMAGE MODEL (GAUSS POINT LEVEL)')
hold on;
%dbstop('122')
subplot(2,1,1);
title('Damage surface (principal stresses axes)')
xlabel('\sigma_{1}')
ylabel('\sigma_{2}')
hold on;
grid on;
q=sigma_u/sqrt(E);

hplot = dibujar_criterio_dano1(ce, nu, q , 'b-', MDtype,n );


%%%%%
if  ntype == 2
    SIGMAP = [0 0;SIGMAP] ;
    mstrain = 4 ;
    hplotquiver = [] ;
    STRAIN = zeros(size(SIGMAP,1),4);
    for   iloc = 1:size(SIGMAP,1)-1
        
        SSS =SIGMAP(iloc,:);
        sigma_bef=[SSS(1) SSS(2) 0  nu*(SSS(1)+SSS(2))];
        
        SSS =SIGMAP(iloc+1,:);
        sigma_0=[SSS(1) SSS(2) 0  nu*(SSS(1)+SSS(2))];
        
        
        %     hplotquiver(end+1) = plot([sigma_bef(1) sigma_0(1)],[sigma_bef(2) sigma_0(2)]) ;
        
        plot( sigma_0(1), sigma_0(2),'b*')
        text( sigma_0(1), sigma_0(2),['P=',num2str(iloc)]);
        
        strain_di =(inv(ce)*sigma_0')';
        STRAIN(iloc+1,:) = strain_di ;
        
    end
end

% PLOTTING (PATH)
% ********
% Divide SIGMAP{end} - SIGMAP{end-1} in istep1 steps

hplotp = [];
[ hplotp hplotl]=plotpathNI(SIGMAP,istep);

[strain] = calstrain_NI(istep,STRAIN) ;
