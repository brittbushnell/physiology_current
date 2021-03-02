ch = 41;



stimResp = (smoothdata(dataT.bins((dataT.numDots > 0), 1:35 ,ch),'gaussian',3))./0.01;
for b = 1:20
    figure
    clf
%     pause(0.1)
    for ndx = 1:9
        subplot(3,3,ndx)
        hold on
        randStims = randi(length(stimResp),[1,10]);
        plot(1:35,stimResp(randStims,:) ,'-','LineWidth',0.5,'color',[0.6 0.6 0.6]);
    end
end