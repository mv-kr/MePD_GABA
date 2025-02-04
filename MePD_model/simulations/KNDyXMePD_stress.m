% Coupling of the KNDy network model with MePD outputs during restraint
% stress
function dx = KNDyXMePD_stress(t,x,par)
dx=zeros(6,1);
%% KNDy model parameters
d1 = par.d1;  % Dyn degradation rate
d2 = par.d2;  % NKB degradation rate 
d3 = par.d3;  % Firing rate reset rate 
k1 = par.k1;  % Maximum Dyn secretion rate
k2 = par.k2;  % Maximum NKB secretion rate
k01 = par.k01;  % Basal Dyn secretion rate 
k02 = par.k02;  % Basal NKB secretion rate 
pr = par.pr;  % Effective strength of synaptic input
v0 = par.v0;  % Maximum rate of neuronal activity increase 
KD = par.KD;  % Dyn IC50
KN = par.KN;  % NKB EC50
Kr1 =par.Kr1;  % Firing rate for half-maximal Dyn secretion  
Kr2 =par.Kr2;  % Firing rate for half-maximal NKB secretion
theta = par.theta; % half-maximal firing rate 
k = par.k; % membrane time constant 
I0= par.I0; % basal activity
je = par.je; % pre-synaptic firing rate
%% MePD model parameters 
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
%% State variables
 Gl = x(1); % MePD glutamate population activity
 Gi = x(2); % MePD GABA population activity
 Ge = x(3); % MePD GABA IN population activity
 Dyn = x(4); % Dyn levels
 NKB = x(5); % NKB levels
 v = x(6); % firing rate of kisspeptin neurons in KNDy

function out=stress(gamma,base)
    out = gamma*(a*t*exp(-r2*t)+b*(1-exp(-r1*t)))+base;
end


% define the inputs into the sigmoid function 

Fl = cll*x(1)-cil*x(2)-cel*x(3)+stress(gamma1,base_l);
Fi = cli*x(1)-cii*x(2)-cei*x(3)+stress(gamma2,base_i);
Fe = cle*x(1)-cie*x(2)-cee*x(3);

% define the sigmoid function 

function out=phi(a,F,theta)
    out = 1./(1+exp(-a.*(F-theta)))-1./(1+exp(a.*theta));
end

% define the system of ODEs

dx(1)=dl*(-Gl+(1-Gl).*phi(al,Fl,thetal)); %glut
dx(2)=di*(-Gi+(1-Gi).*phi(ai,Fi,thetai)); %gaba inter
dx(3)=de*(-Ge+(1-Ge).*phi(ae,Fe,thetae)); %gaba eff

 % Equation for Dyn 
dx(4) = k01 + k1.*v.^2./(v.^2+(Kr1).^2)-Dyn.*d1;

% Equation for NKB 
dx(5) = k02 + k2.*v.^2./(v.^2+(Kr2).^2)*KD.^2./(Dyn.^2+KD.^2)-d2.*NKB;

% Basal activity function
Im=-je*Ge;
I = I0 + Im + pr.*NKB.^2.*v./(NKB.^2+KN.^2);

% Equation for ARC kisspeptin firing rate
dx(6) = v0.*(1./(1+exp(k*(-I+theta))))-d3.*v;
end











