function [dy]= equations(t,y,D,Nin,Al,kb,SP,depth,LAT,li,Idaymean,CMAX,k,fsigma)

Gmax=[1.765057112792909E-005,7.301647456777583E-005]*86400; %Maximal growth rate
Vmax=[4.155700962311181E-006,2.357242642421567E-006]*86400; %Maximal uptake rate
Km  =[1.189352401415061E-002,0.310636619513273]; %Half saturation for Monod kinetics

Gmax=Gmax+Gmax*0.7; % Increase of Gmax due to impact of introducing diel light cycles (Jensen's inequality)

% Light
dv = datevec(t);
DOYh = (t - datenum(dv(1),1,1) + 1);
DOY  = floor(DOYh);
switch li
    case 1   %Constant light
        I = Idaymean(DOY + 1);
    case 2   %Diel light cycles
        HOUR = 24 *(DOYh - DOY);
        I=brock81.csrad(LAT,DOY,HOUR);
end
I = I * exp(-kb*depth); %Light intensity

p = y(1:SP);  %phytoplankton variable (mol C m3)
c = y(SP+1:2*SP);  %carbon quota variable (mol C m3)
n = y(2*SP+1);  %nutrient variable (mol N m3)

Vn =7.5*Vmax.*n./(n+Km); % Nutrient uptake (7.5 = C/N ratio)

Vc =Gmax.*(1 - exp(-Al.*I)); % Carbon uptake

for i=1:SP %Loop for each species
    C  = c(i)./p(i); %Stored carbon relative to functional carbon biomass
    Cmax= CMAX(i); %C-store max
    VC = Vc(i);
    VN = Vn(i);

    Ca=min(1,max(0,1-C/Cmax)); %Droop-like saturation for storing C
    Cb=min(1,max(0,C/Cmax));   %Droop-like saturation for using stored C

    ClimS=max(0,min(1,(Ca).^4./((Ca).^4+k))); %Kevin Flynn saturation
    ClimG=max(0,min(1,(Cb).^4./((Cb).^4+k)));


    if VC>=VN
        Sc(i)=fsigma*(VC- VN)*ClimS; %rate of storing C

        G(i)= VN;               %growth rate
    else
        Sc(i)=fsigma*(VC-VN)*ClimG; %rate of using stored C

        G(i)=VC-Sc(i);         %growth rate
    end
end

dy(1:SP, 1)= (G - D).*p'; %phytoplankton equation
dy(SP+1:2*SP,1) = Sc.*p'-D.*c'; %carbon quota
dy(2*SP+1)   = D.*(Nin-n) -sum(G'.*p./7.5); %nutrient equation
end





