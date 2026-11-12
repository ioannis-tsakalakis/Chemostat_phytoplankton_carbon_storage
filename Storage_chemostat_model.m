
clearvars

run=1;

green=[68 160 122]/255;

if run==1

    %% Phytoplankton traits %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    phyto=[15]; %Choose phytoplankton types to be included in the simulation from the list below
    % E.g. phyto=[1 15] will include Prochlorococcus and the first (smallest) diatom

    % SP1     =  1 Prochlorococcus
    % SP2     =  1 Synechococcus
    % SP3-4   =  2 Pico-eukaryotes
    % SP5-9   =  5 Coccolithophores
    % SP10-14 =  5 Diazotrophs
    % SP15-25 = 11 Diatoms
    % SP26-35 = 10 Dinoflagellates


    SP=length(phyto); %Number of species

    CMAX =[0.3 0.3]; %Maximal storage capacity (Fraction relative to unit functional biomass)

    fsigma=1; % Maximal storage synthesis rate relative to maximal growth rate

    Al=0.012; % Affinity for light (same for all species): (0.012 is same as in DARWIN)

    k=0.0001; %Saturation parameter for Kevin Flynn formulation

    %% Chemostat model parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    Nin=0.1; %0.1 %Nutrient supply (Concentration in the supply chamber)
    Nin0=Nin;

    D=0.3; %Dillution rate of the chemostat system (inflow and outflow)

    li=2;   %Choose 1 for constant light, 2 for diel cycles

    depth=15; %Higher depth just decreases light intensity in the chemostat

    kb=0.04; %Water attenuation coef for light

    LAT=0;   %Latitude (increase latitude to include seasonal dynamics)

    tstep=1/24; %Simulation time step in days
    tmax=40;   %Simulation length in days (360 = 1 year)

    %% Calculation of average light for the scenario of constant light %%%%%%

    Idaymean = zeros(367, 1);
    for di =1:367
        Idaymean(di) = brock81.av_light(LAT, di - 1);
    end

    %% Simulation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    yo=[linspace(0.1,0.1,SP) linspace(0.0001,0.0001,SP) Nin0];

    options=odeset('RelTol',1e-11,'AbsTol',1e-11, 'NonNegative', ones(size(yo)));

    [t,y] = ode45(@equations,[0:tstep:tmax],yo,options,D,Nin,Al,kb,SP,depth,LAT,li,Idaymean,CMAX,k,fsigma);

end

%% Lipid data of Becker et al. 2018 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
lipid_data %TAGs stored by nanophytoplankton at station ALOHA (Becker et al. 2018)
% (1.time, 2.TAGs) x 39 measurements

%Make time starting from day 3
TAGs_nano(:,1)=TAGs_nano(:,1)+20;

r1=20*24:29*24; %range to be plotted
t1=t(r1);       % time range
y1=y(r1,:);     % variables range

%% Plotting %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Plot Functional biomass concentration
figure(1)
plot(t,y(:,1:SP),'Color',green,'LineWidth',2)
ax = gca;
ax.LineWidth =2;
c.LineWidth =2;
%ylim([0 2])
xlim([0 tmax])
xticks(0:2:tmax)
set(gca,'fontsize',10)
legend('model','Location','best')
grid on

% Plot Storage concentration
figure(2)
plot(t1,y1(:,SP+1:2*SP),'Color',green,'LineWidth',3)
hold on

plot(TAGs_nano(1:22,1),TAGs_nano(1:22,2),'Color','k','LineStyle','-','Marker','o','LineWidth',1.5)
plot(TAGs_nano(23:end,1),TAGs_nano(23:end,2),'Color','k','LineStyle','-','Marker','o','LineWidth',1.5)
% Dummy plots for legends
h_dummy1 = plot(nan, nan,'-','Color',green,'LineWidth',3);    % For blue line
h_dummy2 = plot(nan, nan,'-o','Color','k','LineWidth',1.5,'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'none'); % For red line+marker
hold off
ax = gca;
ax.LineWidth =2;
c.LineWidth =2;
set(gca,'fontsize',11)
set(gca,'TickDir','out')
ylim([0.05 0.3])
xlim([20 29])
legend('model','in-situ','Location','best')
ylabel('S (μmolC L^-^1)')
xlabel('Days (July-August)')
xticks(20:tmax)
xticklabels({'26','27','28','29','30','31','01','02','03','04'})
grid on




