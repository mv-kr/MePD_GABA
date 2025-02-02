% Mathematical Model of MePD with Periodic UCN3 input + GABA stimulation 
function xdot=MePDU(t,x,par)
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
B = par.B; % UCN3 sine wave baseline
A = par.A; % UCN3 sine wave amplitude
f = par.f; % sine wave frequency for both UCN3 stim and GABA
gamma1 = par.gamma1; % urocortin to Glut
gamma2 = par.gamma2; % urocortin to GABA int
gamma3 = par.gamma3; % urocortin to GABA eff
GABA_A = par.GABA_A; % GABA amplitude of sine wave
GABA_B = par.GABA_B; % GABA wave baseline 
base_e = par.base_e; % GABA efferents baseline
base_l = par.base_l; % glutamate baseline
base_i = par.base_i; % GABA interneurons baseline
beta1 = par.beta1; % percentange of GABA interactions suppression
beta2 = par.beta2; % percentange of glutamate interactions suppression
% Urocortin stimulation function
function out=urocortin(gamma)
    out = gamma*B+A*sin(2*pi*f*t);
end
% GABA stimulation function
GABA_stim = GABA_B+GABA_A*sin(2*pi*f*t);
% the inputs into the sigmoid function 
Fl = (1-beta2)*cll*x(1)-(1-beta1)*cil*x(2)-(1-beta1)*cel*x(3)+urocortin(gamma1)+base_l;
Fi = (1-beta2)*cli*x(1)-(1-beta1)*cii*x(2)-(1-beta1)*cei*x(3)+urocortin(gamma2)+GABA_stim+base_i;
Fe = (1-beta2)*cle*x(1)-(1-beta1)*cie*x(2)-(1-beta1)*cee*x(3)+GABA_stim+base_e;
% the sigmoid function 
function out=phi(a,F,theta)
    out = 1./(1+exp(-a.*(F-theta)))-1./(1+exp(a.*theta));
end
%the system of ODEs
xdot(1)=dl*(-x(1)+(1-x(1)).*phi(al,Fl,thetal)); %glutamate
xdot(2)=di*(-x(2)+(1-x(2)).*phi(ai,Fi,thetai)); %GABA inter
xdot(3)=de*(-x(3)+(1-x(3)).*phi(ae,Fe,thetae)); %GABA eff
end
