clear all
close all
clc
%% using known values to plot
figure(1)
clf

%subplot(1,2,1)
h=axesm('stereo','origin',[45 45 0]);
axis off;
hold on
% 
% [th,phi,r]=cart2sph(0,0.5,0.5); plot3m(rad2deg(th),rad2deg(phi),r,'o','color',[0.4 0.8 1],'MarkerFaceColor',[0.4 0.8 1],'MarkerSize',12,'LineWidth',1.5); % cyan point is equal model2&3
% [th,phi,r]=cart2sph(0.5,0,0.5); plot3m(rad2deg(th),rad2deg(phi),r,'o','color',[0.9 0.3 0.1],'MarkerSize',12,'LineWidth',1.5); % orange point is equal model 1&3
% [th,phi,r]=cart2sph(0.5,0.5,0); plot3m(rad2deg(th),rad2deg(phi),r,'o','color',[0.7 0 0.7],'MarkerSize',12,'LineWidth',1.5); % purple point is equal model 1&2

[th,phi,r]=cart2sph(1,0,0); plot3m(rad2deg(th),rad2deg(phi),r,'ro','MarkerSize',12,'LineWidth',1.5); % red point is pure model 1
[th,phi,r]=cart2sph(0,1,0); plot3m(rad2deg(th),rad2deg(phi),r,'o','MarkerSize',12,'LineWidth',1.5,'Color',[0.2 0.5 0]); % green point is pure model 2
[th,phi,r]=cart2sph(0,0,1); plot3m(rad2deg(th),rad2deg(phi),r,'bo','MarkerSize',12,'LineWidth',1.5); % blue point is pure model 3
[th,phi,r]=cart2sph(1,1,1); plot3m(rad2deg(th),rad2deg(phi),r,'o','MarkerSize',12,'LineWidth',1.5,'MarkerFaceColor',[0.8 0.6 0.8],'MarkerEdgeColor',[0.8 0.6 0.8]); % red point is pure model 1
[th,phi,r]=cart2sph(sqrt(1/3),sqrt(1/3),sqrt(1/3)); plot3m(rad2deg(th),rad2deg(phi),r,'ok','MarkerSize',13,'LineWidth',2.5); % gray is 0 for all


legend('(1,0,0)','(0,1,0)','(0,0,1)','(1,1,1)','(sqrt1/3,sqrt1/3,sqrt1/3)','Location','southoutside')

% [th,phi,r]=cart2sph(0.5,0.5,0.5); plot3m(rad2deg(th),rad2deg(phi),r,'ko','MarkerSize',12,'LineWidth',1.5); % black point is equal 1 for all
% [th,phi,r]=cart2sph(0,0,0); plot3m(rad2deg(th),rad2deg(phi),r,'o','MarkerSize',12,'LineWidth',1.5,'Color',[0.3 0.3 0.3],'MarkerFaceColor',[0.3 0.3 0.3]); % gray is 0 for all
% [th,phi,r]=cart2sph(1/3,1/3,1/3); plot3m(rad2deg(th),rad2deg(phi),r,'o','MarkerSize',12,'LineWidth',1.5,'Color',[0.3 0 0.3],'MarkerFaceColor',[0.3 0 0.3]); % gray is 0 for all
% [th,phi,r]=cart2sph(10,10,10); plot3m(rad2deg(th),rad2deg(phi),r,'*y','MarkerSize',12,'LineWidth',1.5); % gray is 0 for all

% [th,phi,r]=cart2sph(1,1,1); plot3m(rad2deg(th),rad2deg(phi),r,'o','MarkerSize',12,'LineWidth',1.5,'Color',[0.6 0.3 0.6],'MarkerFaceColor',[0.6 0.3 0.6]); % white is 0 for all
% legend('(0,0.5,0.5)','(0.5,0,0.5)','(0.5,0.5,0)','(1,0,0)','(0,1,0)','(0,0,1)','(0.5,0.5,0.5)','(0,0,0)', 'Location','southoutside')
set(gca,'FontSize',12)

% draw the outlines of the triangle
plot3m(linspace(0,90,90), 0.*ones(1,90),ones(1,90),'k')
plot3m(linspace(0,90,90),90.*ones(1,90),ones(1,90),'k')
plot3m(0.*ones(1,90),linspace(0,90,90),ones(1,90),'k')

% h1=textm(45,90,'Model 1');
% h2=textm(45,0,'Model 2');
% h3=textm(0,45,'Model 3');
% 
% set(h1,'horizontalalignment','left','string','    Model 1')
% set(h2,'horizontalalignment','right','string','Model 2   ')
% set(h3,'horizontalalignment','center','string',sprintf('\n\nModel 3'))

%% linear and log spacing of data sets
figure(2)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 800 800])
set(gcf,'PaperOrientation','Landscape');
h=axesm('stereo','origin',[45 45 0]);
axis off;
plot3m(linspace(0,90,90), 0.*ones(1,90),ones(1,90),'k')
plot3m(linspace(0,90,90),90.*ones(1,90),ones(1,90),'k')
plot3m(0.*ones(1,90),linspace(0,90,90),ones(1,90),'k')

x = linspace(0,1,3);
y = linspace(0,1,3);
z = linspace(0,1,3);

hold on;

for a = 1:length(x)
    for b = 1:length(y)
        for c = 1:length(z)  
            pause(0.02);
            [th,phi,r]=cart2sph(x(a),y(b),z(c)); plot3m(rad2deg(th),rad2deg(phi),r,'o','MarkerSize',10)
            %textm(rad2deg(th),rad2deg(phi),r,sprintf('%.1f',(x(a)+y(b)+z(c)))) 
        end
    end
end
% title({'stereographic, origin (45,45,0)';...
%     'linspaced 1:10'})

x = logspace(0,1,3);
y = logspace(0,1,3);
z = logspace(0,1,3);

hold on;

for a = 1:length(x)
    for b = 1:length(y)
        for c = 1:length(z)  
            pause(0.02);
            [th,phi,r]=cart2sph(x(a),y(b),z(c)); plot3m(rad2deg(th),rad2deg(phi),r,'o','color',[0.7, 0.2, 0.1],'MarkerSize',10)
            %textm(rad2deg(th),rad2deg(phi),r,sprintf('%.1f',(x(a)+y(b)+z(c)))) 
        end
    end
end

x = logspace(1,10,3);
y = logspace(1,10,3);
z = logspace(1,10,3);

hold on;

for a = 1:length(x)
    for b = 1:length(y)
        for c = 1:length(z)  
            pause(0.02);
            [th,phi,r]=cart2sph(x(a),y(b),z(c)); plot3m(rad2deg(th),rad2deg(phi),r,'o','color',[0.1, 0.5, 0.1],'MarkerSize',10)
            textm(rad2deg(th),rad2deg(phi),r,sprintf('(%.1f,%.1f,%.1f)',x(a),y(b),z(c))) 
        end
    end
end