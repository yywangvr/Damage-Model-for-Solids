function [SIGMAP,STRAIN,strain]=recompstr(SIGMAP,nnls_s,nu,ce,STRAIN,mstrain,istep1 ,istep2 ,istep3)
% Re-compute strains
% ------------------
% see CALLBACK_main

for iloc = 1:nnls_s
    sigma_0 = SIGMAP{iloc+1} ;
    % Poisson has changed -->
    % -------------------
    sigma_0(4) = nu*(sigma_0(1)+sigma_0(2)) ;
    SIGMAP{iloc+1} =  sigma_0 ;
    sigma_bef = SIGMAP{iloc} ;
    stress_incre = sigma_0 - sigma_bef ;    

    % Strain
    % ----------------
    strain_di =(inv(ce)*sigma_0')';
    STRAIN{iloc+1} = strain_di ;
end

istep = [istep1 istep2 istep3] ;
% STRAIN EVOLUTION
[strain] = calstrain(istep,mstrain,STRAIN) ;

