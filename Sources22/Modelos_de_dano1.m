
function [rtrial] = Modelos_de_dano1 (MDtype,ce,eps_n1,n)
%**************************************************************************************
%*          Defining damage criterion surface                                        %*
%*                                                                                   %*
%*
%*                          MDtype=  1      : SYMMETRIC                              %*
%*                          MDtype=  2      : ONLY TENSION                           %*
%*                          MDtype=  3      : NON-SYMMETRIC                          %*
%*                                                                                   %*
%*                                                                                   %*
%* OUTPUT:                                                                           %*
%*                          rtrial                                                   %*               
%**************************************************************************************



%**************************************************************************************
if (MDtype==1)      %* Symmetric
   
    
    rtrial= sqrt(eps_n1*ce*eps_n1')  ;

elseif (MDtype==2)  %* Only tension 
   sigma = ce*eps_n1';
   sigma_plus=sigma;
   sigma_plus(sigma_plus<0)=0;
  rtrial=sqrt(eps_n1*sigma_plus); 
    
    
elseif (MDtype==3)  %*Non-symmetric
    sigma = eps_n1*ce;  
    denominat = sum(abs(sigma)); %??
    numerat = sum(sigma(sigma>0)); %??
   
    theta = numerat/denominat; 
    coe=theta+((1-theta)/n);    
    rtrial= coe*sqrt(eps_n1*ce*eps_n1');
                
end
%**************************************************************************************
return