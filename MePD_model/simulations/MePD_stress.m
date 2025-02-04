% Mathematical Model of MePD with UCN3 input immitating restraint stress
function xdot=MePD_stress(t,x,par)
% initialise the system
xdot=zeros(3,1);
% PARAMETERS 
dl = par.dl; % Time Scaling Constant Glut
di = par.di; % Time Scaling Constant GABA int
de = par.de; % Time Scaling Constant GABA eff
cll = par.cll; % Gl self-excitation coupling constant 
cil = par.cil; % Gi to Gl inhibition coupling constant 
cli = par.cli; % Gl to Gi excitation coupling constant 
cii = par.cii; % Gi self-inhibition coupling constant
cel = par.cel; % Ge to Gl inhibition coupling constant 
cei = par.cei; % Ge to Gi inhibition coupling constant
cle = par.cle; % Gl to Ge excitation coupling constant 
cie = par.cie; % Ge to Gi inhibition coupling constant 
cee = par.cee; % Ge self-inhibition coupling constant 
al = par.al; % maximum slope for the Gl response function
ai = par.ai; %  maximum slope  for the Gi response function 
ae = par.ae; %  maximum slope  for the Ge response function 
thetal = par.thetal; % half-maximum firing threshold for Gl response function 
thetai = par.thetai; %  half-maximum firing threshold for Gi response function 
thetae = par.thetae;  % half-maximum firing threshold for Ge response function
a = par.a; % initial growth magnitude during stress 
b = par.b; % plateau during restraint stress
r1 = par.r1; % increase rate parameter during restraint stress 
r2 = par.r2; % decrease rate parameter during restraint stress 
gamma1 = par.gamma1; % stress to Glut
gamma2 = par.gamma2; % stress to GABA int
base_l = par.base_l; % glutamate baseline
base_i = par.base_i; % GABA glutamate
% UCN3 input during restraint stress function
function out=stress(gamma,base)
    out = gamma*(a.*t.*exp(-r2.*t)+b.*(1-exp(-r1.*t)))+base;
end
%the inputs into the sigmoid function 
Fl = cll*x(1)-cil*x(2)-cel*x(3)+stress(gamma1,base_l);
Fi = cli*x(1)-cii*x(2)-cei*x(3)+stress(gamma2,base_i);
Fe = cle*x(1)-cie*x(2)-cee*x(3);
%the sigmoid function 
function out=phi(a,F,theta)
    out = 1./(1+exp(-a.*(F-theta)))-1./(1+exp(a.*theta));
end
%the system of ODEs
xdot(1)=dl*(-x(1)+(1-x(1)).*phi(al,Fl,thetal)); %glut
xdot(2)=di*(-x(2)+(1-x(2)).*phi(ai,Fi,thetai)); %GABA inter
xdot(3)=de*(-x(3)+(1-x(3)).*phi(ae,Fe,thetae)); %GABA eff
end
