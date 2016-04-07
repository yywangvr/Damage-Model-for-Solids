function hplot = dibujar_criterio_dano1(ce,nu,q,tipo_linea,MDtype,n)
%*************************************************************************************
%*                 PLOT DAMAGE SURFACE CRITERIUM: ISOTROPIC MODEL                             %*
%*                                                                                  %*
%*      function [ce] = tensor_elastico (Eprop, ntype)                    %*
%*                                                                                  %*
%*      INPUTS                                                       %*
%*                                                                                  %*
%*                    Eprop(4)    vector de propiedades de material                 %*
%*                                      Eprop(1)=  E------>modulo de Young          %*
%*                                      Eprop(2)=  nu----->modulo de Poisson        %*
%*                                      Eprop(3)=  H----->modulo de Softening/hard. %*
%*                                      Eprop(4)=sigma_u----->tensi???n ???ltima        %*
%*                     ntype                                 %*
%*                                 ntype=1  plane stress                            %*
%*                                 ntype=2  plane strain                            %*
%*                                 ntype=3  3D                                      %*
%*                     ce(4,4)     Constitutive elastic tensor  (PLANE S.       )    %*
%*                     ce(6,6)                                  ( 3D)                %*
%*************************************************************************************


%*************************************************************************************
%*        Inverse ce                                                                %*
ce_inv=inv(ce);
c11=ce_inv(1,1);
c22=ce_inv(2,2);
c12=ce_inv(1,2);
c21=c12;
c14=ce_inv(1,4);
c24=ce_inv(2,4);
%**************************************************************************************







%**************************************************************************************
% POLAR COORDINATES
if MDtype==1
    tetha=[0:0.01:2*pi];
    %**************************************************************************************
    %* RADIUS
    D=size(tetha);                       %*  Range
    m1=cos(tetha);                       %*
    m2=sin(tetha);                       %*
    Contador=D(1,2);                     %*
    
    
    radio = zeros(1,Contador) ;
    s1    = zeros(1,Contador) ;
    s2    = zeros(1,Contador) ;
    
    for i=1:Contador
        radio(i)= q/sqrt([m1(i) m2(i) 0 nu*(m1(i)+m2(i))]*ce_inv*[m1(i) m2(i) 0 ...
            nu*(m1(i)+m2(i))]');
        
        s1(i)=radio(i)*m1(i);
        s2(i)=radio(i)*m2(i);  
        
    end
    hplot =plot(s1,s2,tipo_linea);
    
    
elseif MDtype==2
 %   Comment/delete lines below once you have implemented this case
  %  *******************************************************
   tetha=[-0.5*pi:0.01:pi];
    %**************************************************************************************
    %* RADIUS
    D=size(tetha);                       %*  Range
    m1=cos(tetha);
    n1=m1;
    n1(n1<0)=0;
    m2=sin(tetha);
    n2=m2;
    n2(n2<0)=0;
    
    Contador=D(1,2);                     % 
    radio = zeros(1,Contador) ;
    s1    = zeros(1,Contador) ;
    s2    = zeros(1,Contador) ;
    
    for i=1:Contador
      
        radio(i)= q/sqrt([n1(i) n2(i) 0 nu*(n1(i)+n2(i))]*ce_inv*[m1(i) m2(i) 0 ...
        nu*(m1(i)+m2(i))]');     
        s1(i)=radio(i)*m1(i);
        s2(i)=radio(i)*m2(i);  
        
    end
    
    hplot =plot(s1,s2,tipo_linea);
    axis([-400 300 -400 300]);
    
elseif MDtype==3
    
 tetha=[0:0.01:2*pi];
    %**************************************************************************************
    %* RADIUS
    D=size(tetha);                       %*  Range
    m1=cos(tetha); 
    m2=sin(tetha);
    Contador=D(1,2);                       
    radio = zeros(1,Contador) ;
    s1    = zeros(1,Contador) ;
    s2    = zeros(1,Contador) ;
    
    for i=1:Contador
       
        denominant= abs(m1(i))+abs(m2(i));
        a=m1(i);b=m2(i);
        a(a<0)=0; b(b<0)=0;
        numerat=a+b;
        rate = numerat/denominant;
        
        radio(i)=q/((rate+(1-rate)/n) *sqrt([m1(i) m2(i) 0 nu*(m1(i)+m2(i))]*ce_inv*[m1(i) m2(i) 0 ...
        nu*(m1(i)+m2(i))]'));
    
        s1(i)=radio(i)*m1(i);
        s2(i)=radio(i)*m2(i);  
        
    end
    
    hplot =plot(s1,s2,tipo_linea);
    % axis([-400 300 -400 300]);
    



    
end
%**************************************************************************************



%**************************************************************************************
return



