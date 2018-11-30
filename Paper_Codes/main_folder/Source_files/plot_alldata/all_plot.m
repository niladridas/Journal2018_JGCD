clc;clear;close all;
% Plot set 1:
A1 = load('prop_data_OT50.mat');
A2 = load('prop_data_EnKF50.mat');

% 
% OTpc = reshape(A1.delprop_data_OT.prop_pointcloud,[6 500]);
% EnKFpc = reshape(A2.delprop_data_EnKF.prop_pointcloud,[6 500]);
% 
% scatter3(OTpc(1,:),OTpc(2,:),OTpc(3,:));hold on
% scatter3(EnKFpc(1,:),EnKFpc(2,:),EnKFpc(3,:));



% % a11 = A1.OT_stat.mean_est_OT/1000;
% % a12 = sqrt(A1.OT_stat.var_est_OT)*100;
% % a21 = A2.EnKF_stat.mean_est_EnKF/1000;
% % a22 = sqrt(A2.EnKF_stat.var_est_EnKF)*100;
% 
% 
% a11 = sqrt(A1.OT_stat.mean_var_OT);
% a21 = sqrt(A2.EnKF_stat.mean_var_EnKF);
% 
% figure(1)
% % for samples = 50
% % for i = 1:3 % first 3 state variables
% subplot(2,2,1)
% % yyaxis left;
% plot(1:17,a11(:,1:3));
% % errorbar(1:17,a11(:,i+3),a12(:,i+3));
% subplot(2,2,2)
% %     yyaxis left;
% plot(1:17,a21(:,1:3));
% % errorbar(1:17,a21(:,1:3),a22(:,i+3));
% % end
% subplot(2,2,3)
% plot(1:17,a11(:,4:6));hold on
% subplot(2,2,4)
% plot(1:17,a21(:,4:6));hold on





% B1 = load('OT_stat100.mat');
% B2 = load('EnKF_stat100.mat');
% 
% b11 = B1.OT_stat.mean_est_OT;
% b12 = B1.OT_stat.var_est_OT;
% b21 = B2.EnKF_stat.mean_est_EnKF;
% b22 = B2.EnKF_stat.var_est_EnKF;




% function plot_norepeat(data_OT,data_ENKF, nobs)
%     
%     if (sum(nobs) ~= numel(data_OT(:,1)))||(sum(nobs) ~= numel(data_ENKF(:,1)))
%         error('No of observation and no of data pts do not match.')
%     end
%     nPass = numel(nobs);
%     obsNum = 1:sum(nobs);
%     
%     nSubplots = size(data_OT,2);
%     
%     % plot position 
%     figure(1); 
%     for iSubplot = 1:3
%         subplot(1,3,iSubplot)
%         
%         prevPass = 0;
%         for iPass = 1:nPass
%             % draw scatter plots and connect by solid line
%             scatter(obsNum(prevPass+1:prevPass+nobs(iPass)),data_OT(prevPass+1:prevPass+nobs(iPass),iSubplot),'bo','filled'); hold on; drawnow;
%             plot(obsNum(prevPass+1:prevPass+nobs(iPass)),data_OT(prevPass+1:prevPass+nobs(iPass),iSubplot),'b','Linewidth',1)
% 
%             scatter(obsNum(prevPass+1:prevPass+nobs(iPass)),data_ENKF(prevPass+1:prevPass+nobs(iPass),iSubplot),'ro','filled'); hold on; drawnow;
%             plot(obsNum(prevPass+1:prevPass+nobs(iPass)),data_ENKF(prevPass+1:prevPass+nobs(iPass),iSubplot),'r','Linewidth',1)
%             prevPass = prevPass+nobs(iPass);
%             
%             % draw dotted line conneting two passes
%             if ~(iPass == nPass)
%                 plot(obsNum(prevPass:prevPass+1),data_OT(prevPass:prevPass+1,iSubplot),'b--','Linewidth',1)
%                 plot(obsNum(prevPass:prevPass+1),data_ENKF(prevPass:prevPass+1,iSubplot),'r--','Linewidth',1)
%             end
%         end
% %         scatter(obsNum,data_OT(:,iSubplot),'bo'); hold on; drawnow;
% %         plot(obsNum,data_OT(:,iSubplot),'b--')
% %         
% %         scatter(obsNum,data_ENKF(:,iSubplot),'ro'); hold on; drawnow;
% %         plot(obsNum,data_ENKF(:,iSubplot),'r--')
%     end
%     
%     subplot(1,3,1)
%     ylabel('$\sigma _x$ [m]','Interpreter','Latex','FontSize',14);
%     subplot(1,3,2)
%     xlabel('Observation number','Interpreter','Latex','FontSize',14);
%     ylabel('$\sigma _y$ [m]','Interpreter','Latex','FontSize',14);
%     title('Standard Deviation in Position','Interpreter','Latex','FontSize',14);
%     subplot(1,3,3)
%     ylabel('$\sigma _z [m]$','Interpreter','Latex','FontSize',14);
%     
%     print('plot1','-depsc');
%     
%     if nSubplots == 6
%         % plot velocity 
%         figure(2); 
%         for iSubplot = 4:6
%             subplot(1,3,iSubplot-3)
% 
%             prevPass = 0;
%             for iPass = 1:nPass
%                 % draw scatter plots and connect by solid line
%                 scatter(obsNum(prevPass+1:prevPass+nobs(iPass)),data_OT(prevPass+1:prevPass+nobs(iPass),iSubplot),'bo','filled'); hold on; drawnow;
%                 plot(obsNum(prevPass+1:prevPass+nobs(iPass)),data_OT(prevPass+1:prevPass+nobs(iPass),iSubplot),'b','Linewidth',1)
% 
%                 scatter(obsNum(prevPass+1:prevPass+nobs(iPass)),data_ENKF(prevPass+1:prevPass+nobs(iPass),iSubplot),'ro','filled'); hold on; drawnow;
%                 plot(obsNum(prevPass+1:prevPass+nobs(iPass)),data_ENKF(prevPass+1:prevPass+nobs(iPass),iSubplot),'r','Linewidth',1)
%                 prevPass = prevPass+nobs(iPass);
%                 
%                 % draw dotted line conneting two passes
%                 if ~(iPass == nPass)
%                     plot(obsNum(prevPass:prevPass+1),data_OT(prevPass:prevPass+1,iSubplot),'b--','Linewidth',1)
%                     plot(obsNum(prevPass:prevPass+1),data_ENKF(prevPass:prevPass+1,iSubplot),'r--','Linewidth',1)
%                 end
%             end
% 
% %                 scatter(obsNum,data_OT(:,iSubplot),'bo'); hold on; drawnow;
% %                 plot(obsNum,data_OT(:,iSubplot),'b--')
% %     
% %                 scatter(obsNum,data_ENKF(:,iSubplot),'ro'); hold on; drawnow;
% %                 plot(obsNum,data_ENKF(:,iSubplot),'r--')
%         end
% 
%         subplot(1,3,1)
%         ylabel('$\sigma _{v_x}$ [m/s]','Interpreter','Latex','FontSize',14);
%         subplot(1,3,2)
%         xlabel('Observation number','Interpreter','Latex','FontSize',14);
%         ylabel('$\sigma _{v_y}$ [m/s]','Interpreter','Latex','FontSize',14);
%         title('Standard Deviation in Velocity','Interpreter','Latex','FontSize',14);
%         subplot(1,3,3)
%         ylabel('$\sigma _{v_z}$ [m/s]','Interpreter','Latex','FontSize',14);
%     end
%         print('plot2','-depsc');
% % end
