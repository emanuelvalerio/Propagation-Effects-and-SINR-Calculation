%         DEVELOPMENT BY EMANUEL VALERIO PEREIRA              %


% i -> integer          vt -> vectors in general (indepedent of element type)
% d -> double           mt -> matrices in general (indepedent of element type)
% b -> boolean          s -> strings
% c -> complex 

iNumBS = 4; % Number of base stations
iTMS = 4;
dRadius = 500; % Distance between adjacent BS in meters

% vector of BSs' positions 
vtBSPos = [0 dRadius * exp(-j*[0 2*pi/3 -2*pi/3])];
vtnodeC = [0 0];

% Calculating the points of the circle corresponding to the coverage area
vth = 0:pi/50:2*pi;

xunit = dRadius * cos(vth) + dRadius*cos(2*pi/3);
yunit = dRadius * sin(vth) + dRadius*sin(2*pi/3);

[theta1,rho1] = cart2pol(xunit,yunit);

xunit = dRadius * cos(vth) + dRadius*cos(0);
yunit = dRadius * sin(vth) + dRadius*sin(0);
[theta2,rho2] = cart2pol(xunit,yunit);

xunit = dRadius * cos(vth) + dRadius*cos(-2*pi/3);
yunit = dRadius * sin(vth) + dRadius*sin(-2*pi/3);
[theta3,rho3] = cart2pol(xunit,yunit);

figure(1)
% Plotting the ERB's
p = polarplot(vtBSPos(1,1),"k<");
p.MarkerSize = 15;
hold on
p = polarplot(vtBSPos(1,4),"g<");
p.MarkerSize = 15;
p = polarplot(vtBSPos(1,2),"b<");
p.MarkerSize = 15;
p = polarplot(vtBSPos(1,3),"r<");
p.MarkerSize = 15;
% Plotting the central node
 p = polarplot(vtnodeC,"O");
p.Color = "magenta";
% Plotting the coverage area of each ERB'S
polarplot(vth,dRadius+zeros(size(vth)),"k");
polarplot(theta1,rho1,"g");
polarplot(theta2,rho2,"b");
polarplot(theta3,rho3,"r");

% Creating important variables,matrices and vectors
n = 1;
iRPdbm = 43; % received power in dbm
iRPln = dbm2lin(iRPdbm); % received power in linear scale
iPn = -116; % avarage noise power in dBm
dpn = dbm2lin(iPn); % avarage noise power in linear scale
iNumRept = 5000 ; % Number of repetitions

mtDistanceskm = zeros(iNumBS,iTMS);
mtLoss = zeros(iNumBS,iTMS);
mtGainPath = zeros(iNumBS,iTMS);
mtGainShadow = zeros(iNumBS,iTMS);
mtGainFadding = zeros(iNumBS,iTMS);
mtTransmitionPower = iRPln*ones(iNumBS,iTMS);
mtReceivedPower = zeros(iNumBS,iTMS);
vtSINR = zeros(iNumRept,iNumBS);

for i = 1:iNumRept
        % Create random point limited for cicle(0,0)
        [x1 y1] = pol2cart(0,0);
        [x2 y2] = pol2cart(2*pi/3,500);
        [x3 y3] = pol2cart(0,500);
        [x4 y4] = pol2cart(-2*pi/3,500);
        
        t1 = 2*pi*rand(n,1);
        r1 = dRadius.*sqrt(rand(n,1));
        
        x_ERB1 = x1 + r1.*cos(t1);
        y_ERB1 = y1 + r1.*sin(t1);
        
        % Create random point limited for cicle(500,2*pi/3)
        t2 = 2*pi*rand(n,1);
        r2 = dRadius*sqrt(rand(n,1));
        
        x_ERB2 = x2 + r2.*cos(t2);
        y_ERB2 = y2 + r2.*sin(t2);
        
        % Create random point limited for cicle(500,0)
        r3 = dRadius*sqrt(rand(n,1));
        t3 = 2*pi*rand(n,1);
        
        x_ERB3 = x3 + r3.*cos(t3);
        y_ERB3 = y3 + r3.*sin(t3);
        
        % Create random point limited for cicle(500,-2*pi/3)
        r4 = dRadius*sqrt(rand(n,1));
        t4 = 2*pi*rand(n,1);
        
        x_ERB4 = x4 + r4.*cos(t4);
        y_ERB4 = y4 + r4.*sin(t4);
        
        %  Switching back to polar scale
        [theta_ERB1,rho_ERB1] = cart2pol(x_ERB1,y_ERB1);
        [theta_ERB2,rho_ERB2] = cart2pol(x_ERB2,y_ERB2);
        [theta_ERB3,rho_ERB3] = cart2pol(x_ERB3,y_ERB3);
        [theta_ERB4,rho_ERB4] = cart2pol(x_ERB4,y_ERB4);
        
        
        % Path gain calculation
        
        posTM = [t1,r1;theta_ERB2,rho_ERB2;theta_ERB3,rho_ERB3;theta_ERB4,rho_ERB4];
        posERB = [0,0;2*pi/3,500;0,500;-2*pi/3,500];
        
        mtDistanceskm = distancef(posERB,posTM); % Distance between ERB and TM in km
        mtLoss = pathLoss(mtDistanceskm); % Loss path
        mtGainPath = gainPath(mtLoss); % Gain path in linear scale gij
        mtGainShadow = gainShadowing(iNumBS,iTMS,0,8); % Gain shadowing in linear scale gxij
        mtGainFadding = gainFastFadding(iNumBS,iTMS,0,(1/sqrt(2)));
        mtReceivedPower = mtTransmitionPower.*mtGainPath.*mtGainShadow.*mtGainFadding;
        vtSINR(i,:) = calculateSINR(iNumBS,iTMS,mtReceivedPower,dpn);
end

% Ploting some types of graphs

p = polarplot(theta_ERB1,rho_ERB1,"ks");
p.MarkerSize = 10;
p = polarplot(theta_ERB2,rho_ERB2,"gs");
p.MarkerSize = 10;
p=polarplot(theta_ERB3,rho_ERB3,"bs");
p.MarkerSize = 10;
p = polarplot(theta_ERB4,rho_ERB4,"rs");
p.MarkerSize = 10;
legend("ERB 1","ERB 2","ERB 3","ERB 4","Central Node","Coverage area 1","Coverage area 2" ...
    ,"Coverage area 3","Coverage area 4","TM 1","TM 2","TM 3","TM 4");

figure(3)
subplot(2,2,1)
histogram(vtSINR(:,1));
xlabel('SINR in dB','fontweight','bold','fontsize',8);
ylabel('number of samples','fontweight','bold','fontsize',10);
colormap lines
title("Result for ERB_1 and TM_1 ");
subplot(2,2,2)
histogram(vtSINR(:,2));
xlabel('SINR in dB','fontweight','bold','fontsize',8);
ylabel('number of samples','fontweight','bold','fontsize',10);
colormap lines
title("Result for ERB_2 and TM_2 ");
subplot(2,2,3)
histogram(vtSINR(:,3));
xlabel('SINR in dB','fontweight','bold','fontsize',8);
ylabel('number of samples','fontweight','bold','fontsize',10);
colormap lines
title("Result for ERB_3 and TM_3 ");
subplot(2,2,4)
histogram(vtSINR(:,4));
xlabel('SINR in dB','fontweight','bold','fontsize',8);
ylabel('number of samples','fontweight','bold','fontsize',10);
colormap lines
title("Result for ERB_4 and TM_4 ");

figure(4)
cdfplot(vtSINR(:,1));
hold on
grid on
cdfplot(vtSINR(:,2));
cdfplot(vtSINR(:,3));
cdfplot(vtSINR(:,4));
legend("ERB_1 TM_1","ERB_2 TM_2","ERB_3 TM_3","ERB_4 TM_4");
xlabel("SINR in dB");
hold off