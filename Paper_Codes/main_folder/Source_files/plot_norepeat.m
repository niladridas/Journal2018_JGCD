%--------------------------------------------------------------------------
% Version  Date           Author      Mod History
%--------------------------------------------------------------------------
% 1        25 March 2018  Vedang D.   Inital version
% 2        26 March 2018  Vedang D.   code for plotting velocity std dev
%--------------------------------------------------------------------------

% Input: 
% data_OT - OT data to plot
% data_ENKF -  ENKF data to plot
% nobs - array specifying no of observation in each pass
% Output: 
% Plots the corresponding columns of data_OT and data_ENKF together
% Creates separate plots for different columns

function plot_norepeat(data_OT,data_ENKF, nobs)
    
    if (sum(nobs) ~= numel(data_OT(:,1)))||(sum(nobs) ~= numel(data_ENKF(:,1)))
        error('No of observation and no of data pts do not match.')
    end
    nPass = numel(nobs);
    obsNum = 1:sum(nobs);
    
    nSubplots = size(data_OT,2);
    
    % plot position 
    figure(1); 
    for iSubplot = 1:3
        subplot(1,3,iSubplot)
        
        prevPass = 0;
        for iPass = 1:nPass
            % draw scatter plots and connect by solid line
            scatter(obsNum(prevPass+1:prevPass+nobs(iPass)),data_OT(prevPass+1:prevPass+nobs(iPass),iSubplot),'bo','filled'); hold on; drawnow;
            plot(obsNum(prevPass+1:prevPass+nobs(iPass)),data_OT(prevPass+1:prevPass+nobs(iPass),iSubplot),'b','Linewidth',1)

            scatter(obsNum(prevPass+1:prevPass+nobs(iPass)),data_ENKF(prevPass+1:prevPass+nobs(iPass),iSubplot),'ro','filled'); hold on; drawnow;
            plot(obsNum(prevPass+1:prevPass+nobs(iPass)),data_ENKF(prevPass+1:prevPass+nobs(iPass),iSubplot),'r','Linewidth',1)
            prevPass = prevPass+nobs(iPass);
            
            % draw dotted line conneting two passes
            if ~(iPass == nPass)
                plot(obsNum(prevPass:prevPass+1),data_OT(prevPass:prevPass+1,iSubplot),'b--','Linewidth',1)
                plot(obsNum(prevPass:prevPass+1),data_ENKF(prevPass:prevPass+1,iSubplot),'r--','Linewidth',1)
            end
        end
%         scatter(obsNum,data_OT(:,iSubplot),'bo'); hold on; drawnow;
%         plot(obsNum,data_OT(:,iSubplot),'b--')
%         
%         scatter(obsNum,data_ENKF(:,iSubplot),'ro'); hold on; drawnow;
%         plot(obsNum,data_ENKF(:,iSubplot),'r--')
    end
    
    subplot(1,3,1)
    ylabel('$\sigma _x$ [m]','Interpreter','Latex','FontSize',14);
    subplot(1,3,2)
    xlabel('Observation number','Interpreter','Latex','FontSize',14);
    ylabel('$\sigma _y$ [m]','Interpreter','Latex','FontSize',14);
    title('Standard Deviation in Position','Interpreter','Latex','FontSize',14);
    subplot(1,3,3)
    ylabel('$\sigma _z [m]$','Interpreter','Latex','FontSize',14);
    
    print('plot1','-depsc');
    
    if nSubplots == 6
        % plot velocity 
        figure(2); 
        for iSubplot = 4:6
            subplot(1,3,iSubplot-3)

            prevPass = 0;
            for iPass = 1:nPass
                % draw scatter plots and connect by solid line
                scatter(obsNum(prevPass+1:prevPass+nobs(iPass)),data_OT(prevPass+1:prevPass+nobs(iPass),iSubplot),'bo','filled'); hold on; drawnow;
                plot(obsNum(prevPass+1:prevPass+nobs(iPass)),data_OT(prevPass+1:prevPass+nobs(iPass),iSubplot),'b','Linewidth',1)

                scatter(obsNum(prevPass+1:prevPass+nobs(iPass)),data_ENKF(prevPass+1:prevPass+nobs(iPass),iSubplot),'ro','filled'); hold on; drawnow;
                plot(obsNum(prevPass+1:prevPass+nobs(iPass)),data_ENKF(prevPass+1:prevPass+nobs(iPass),iSubplot),'r','Linewidth',1)
                prevPass = prevPass+nobs(iPass);
                
                % draw dotted line conneting two passes
                if ~(iPass == nPass)
                    plot(obsNum(prevPass:prevPass+1),data_OT(prevPass:prevPass+1,iSubplot),'b--','Linewidth',1)
                    plot(obsNum(prevPass:prevPass+1),data_ENKF(prevPass:prevPass+1,iSubplot),'r--','Linewidth',1)
                end
            end

%                 scatter(obsNum,data_OT(:,iSubplot),'bo'); hold on; drawnow;
%                 plot(obsNum,data_OT(:,iSubplot),'b--')
%     
%                 scatter(obsNum,data_ENKF(:,iSubplot),'ro'); hold on; drawnow;
%                 plot(obsNum,data_ENKF(:,iSubplot),'r--')
        end

        subplot(1,3,1)
        ylabel('$\sigma _{v_x}$ [m/s]','Interpreter','Latex','FontSize',14);
        subplot(1,3,2)
        xlabel('Observation number','Interpreter','Latex','FontSize',14);
        ylabel('$\sigma _{v_y}$ [m/s]','Interpreter','Latex','FontSize',14);
        title('Standard Deviation in Velocity','Interpreter','Latex','FontSize',14);
        subplot(1,3,3)
        ylabel('$\sigma _{v_z}$ [m/s]','Interpreter','Latex','FontSize',14);
    end
        print('plot2','-depsc');
end
