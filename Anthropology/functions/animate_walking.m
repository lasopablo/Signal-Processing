function animate_walking(markers,coms,com)

markers_names= fieldnames(markers);
first_marker= markers_names{1};
eval(['ends=length(markers.' first_marker ');']); % define variable 'ends'
% marker_num= length(markers_names);
% mark= 8;
% skel= 5;

for i=1:5:ends % PLOT MARKERS:    

    plot_marker(markers.RGT(i,:)); % right side
    hold on
    plot_marker(markers.RLE(i,:));
    plot_marker(markers.RLM(i,:));
    plot_marker(markers.RFM2(i,:));
    
    plot_marker(markers.LGT(i,:)); % left side
    plot_marker(markers.LLE(i,:));
    plot_marker(markers.LLM(i,:));
    plot_marker(markers.LFM2(i,:));

%     PEL(i,:)=mean([markers.RGT(i,:);markers.LGT(i,:)]); % trunk
%     plot_marker(PEL(i,:));
    plot_marker(markers.C7(i,:))
    plot_marker(markers.PEL(i,:))
%     plot_marker(markers.L4(i,:))

    % PLOT segments:
    plot_segment(markers.RGT(i,:),markers.RLE(i,:))
    plot_segment(markers.RLE(i,:),markers.RLM(i,:))
    plot_segment(markers.RLM(i,:),markers.RFM2(i,:))
    
    plot_segment(markers.LGT(i,:),markers.LLE(i,:))
    plot_segment(markers.LLE(i,:),markers.LLM(i,:))
    plot_segment(markers.LLM(i,:),markers.LFM2(i,:))
    
    plot_segment(markers.RGT(i,:),markers.LGT(i,:))
    plot_segment(markers.C7(i,:),markers.PEL(i,:))
    
    %% PLOT COMS
    plot_com(coms.com_RT(i,:))
    plot_com(coms.com_RS(i,:))
    plot_com(coms.com_RF(i,:))

    plot_com(coms.com_LT(i,:))
    plot_com(coms.com_LS(i,:))
    plot_com(coms.com_LF(i,:))

%     plot_com(coms.com_TA(i,:))
%     plot_com(coms.com_P(i,:))

%     plot_com(com(i,:))
    hold off 

    %%%%% executing time + waiting = 0.04 %%%%%  
    tmpAspect= daspect();
    daspect(tmpAspect([1 1 1]));
    pause(0.04)

    view([0 0])
    axis([-2000 4000 -1500 -400 0 1900])    
    xlabel('x')
    ylabel('y')
    zlabel('z')
    grid on
end

close all