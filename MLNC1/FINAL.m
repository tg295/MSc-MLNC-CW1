%% Load london
load ('london.mat')
%% Clean data
Prices.combined = [Prices.location Prices.rent];
Clean = Prices.combined(Prices.combined(:,1)>=51.3 & Prices.combined(:,1)<51.7 & Prices.combined(:,2)>=-0.488 & Prices.combined(:,2)<0.225, :);
%Limits defined from M25

%% Randomise and separate
Clean=Clean(randperm(end),:);%Allows for model to be cross-validated for each run through
xClean=Clean(:,1);
yClean=Clean(:,2);
pClean=Clean(:,3);
%% 3D plot with clean data
figure
subplot(2,2,1)
scatter3(yClean,xClean,pClean,2 ,pClean);
ylim([51.3 51.7])
xlim([-0.5 0.23])
ylabel('latitude[^\circ]')
xlabel('longitude[^\circ]')
zlabel('GBP PCM [£]')
hcb=colorbar
colormap(jet)
title('Rental price PCM against location for clean London data')
title(hcb,'PCM [£]')

subplot(2,2,2)
scatter3(yClean,xClean,pClean,1 ,pClean);
ylim([51.3 51.7])
xlim([-0.5 0.23])
ylabel('latitude[^\circ]')
xlabel('longitude[^\circ]')
zlabel('GBP PCM [£]')
hcb=colorbar
colormap(jet)
title(hcb,'PCM [£]')
view(2);

subplot(2,2,3)
scatter3(yClean,xClean,pClean,6 ,pClean);
ylim([51.3 51.7])
xlim([-0.5 0.23])
ylabel('latitude[^\circ]')
xlabel('longitude[^\circ]')
zlabel('GBP PCM [£]')
hcb=colorbar
colormap(jet)
title(hcb,'PCM [£]')
view([90 0]);

set(gcf, 'Position', [100, 100, 1500, 700])
%% Cutting data for crossvalidation
inClean=[xClean yClean];
nrows=round(0.2*length(inClean));
for k=1:5 %k corresponds to number of folds 
    if k==5
        data.In{k}=inClean((k-1)*nrows+1:end,:);
        data.Out{k}=pClean((k-1)*nrows+1:end,:);
    else
    data.In{k}=inClean((k-1)*nrows+1:k*nrows,:);
    data.Out{k}=pClean((k-1)*nrows+1:k*nrows,:);
    end
end

%% Training and testing Q2&3
error=zeros(5,1)
for k=1:5
    %Crossvalidation
        trainIn=[data.In{mod(k,5)+1};data.In{mod(k+1,5)+1};data.In{mod(k+2,5)+1};data.In{mod(k+3,5)+1}];
        trainOut=[data.Out{mod(k,5)+1};data.Out{mod(k+1,5)+1};data.Out{mod(k+2,5)+1};data.Out{mod(k+3,5)+1}];
        testIn=data.In{mod(k+4,5)+1};
        testOut=data.Out{mod(k+4,5)+1};
        %Train regressor 
        [ params ] = trainRegressor(trainIn, trainOut)
        %Test regressor 
        [ val ] = testRegressor(testIn, params)
        %Root mean squared error
        error(k) =sqrt(sum((val-testOut).^2)/numel(val));
end
%Mean of k-fold errors
errorMean=(sum(error(:,1))/5);

%Clusterplot of London separated into grid and corresponding mu's
% figure
% colors=jet(numGaussians);
% for i=1:numGaussians
% plot(temp{1,i}(:,1) , temp{1,i}(:,2),'o','color',colors(i,:))
% plot(param.mu{1,i}(:,1), param.mu{1,i}(:,2),'*','markers',12)
% hold on;
% end
% xlim([-0.5 0.23])
% ylim([51.3 51.7])
% xlabel('longitude[^\circ]')
% ylabel('latitude[^\circ]')
% legend('Mean for each cluster','Clustered clean data')
% title('Clustered data (Clusters=12)')
% grid on 


%% Sanity check 
sanityCheck(@trainRegressor,@testRegressor)

%% Heatmap
figure
heatmapRent(@testRegressor, params)%For an effective heatmap, limits should be changed to -0.5<Lat<0.23 and 51.3<Long<51.7

%% Q5 Personalised tube 
%Faux home tube top name and coordinates 
[TubeStop, TubeCoor] = personalisedTube(1439118)
%Faux tube stop rental price predicted by model 
TubeCoor1=[TubeCoor;TubeCoor];%input needs to be at least a 1x2 matrix
[ val ] = testRegressor(TubeCoor1, params)
%Compare my tube with sample data 
MyTube=[TubeCoor(:,1),TubeCoor(:,2),val(1,:)];
MyTubePrice=val(1,:);
TubeArea = Prices.combined(Prices.combined(:,1)>=51.5625 & Prices.combined(:,1)<51.5825 & Prices.combined(:,2)>=-0.214 & Prices.combined(:,2)<-0.174, :);

MeanTubePrice = mean(TubeArea(:,3));%average price of property surrounding local area of my tube 
dTube=MyTubePrice-MeanTubePrice;%difference between the price of living at my tube calculated by the model compared to average prices of surrounding area

%Plot comparing faux home tube stop wth surrounding area
figure
subplot(2,2,1)
scatter3(yClean,xClean,pClean,9 ,pClean);
hold on
scatter3(MyTube(:,2),MyTube(:,1),MyTube(:,3),24,'gd','filled')
hold on 
scatter3(TubeArea(:,2),TubeArea(:,1),TubeArea(:,3),25 ,'x','m')
xlim([-0.25 -0.15])
ylim([51.55 51.59])
zlim([0 6000])
xlabel('longitude[^\circ]')
ylabel('latitude[^\circ]')
zlabel('GBP PCM [£]')
hcb=colorbar
title(hcb,'PCM [£]')
view(3)
title('Price of rental properties in and around Golders Green')
hold off

subplot(2,2,2)
scatter3(yClean,xClean,pClean,9 ,pClean);
hold on
scatter3(MyTube(:,2),MyTube(:,1),MyTube(:,3),24,'gd','filled')
hold on 
scatter3(TubeArea(:,2),TubeArea(:,1),TubeArea(:,3),25 ,'x','m')
xlim([-0.25 -0.15])
ylim([51.55 51.59])
zlim([0 6000])
xlabel('longitude[^\circ]')
ylabel('latitude[^\circ]')
zlabel('GBP PCM [£]')
hcb=colorbar
title(hcb,'PCM [£]')
view(2);
hold off

subplot(2,2,3)
Cleanscat=scatter3(yClean,xClean,pClean,9 ,pClean);
hold on
MyTubescat=scatter3(MyTube(:,2),MyTube(:,1),MyTube(:,3),24,'gd','filled')
hold on 
TubeAreascat=scatter3(TubeArea(:,2),TubeArea(:,1),TubeArea(:,3),25 ,'x','m')
xlim([-0.25 -0.15])
ylim([51.55 51.59])
zlim([0 6000])
xlabel('longitude[^\circ]')
ylabel('latitude[^\circ]')
zlabel('GBP PCM [£]')
hcb=colorbar
title(hcb,'PCM [£]')
view([90 0]);
        
h = [Cleanscat(1);MyTubescat;TubeAreascat(1)];        
legend(h,'Clean data','My personal tube','Rentals surrounding tube area');        
set(gcf, 'Position', [100, 100, 1500, 700])
hold off

