%% Theo Bacon Gardner, CID: 1439118
function [ params ] = trainRegressor(in, out)
% Number of Guassian basis function
numGaussians = 30;
baseFuncs=cell(numGaussians+1,1);
% Initialising variables
%Creating gridpoints
muLong=linspace(-0.4,0.2,6);
muLat=linspace(51.35,51.65,5);
[xlat xlong]=meshgrid(muLat,muLong);
xcomb=[xlat(:) xlong(:)];
p=0;
%Space between grid centroids
dLat=muLat(2)-muLat(1);
dLong=muLong(2)-muLong(1);
%initialise variables 
covar1={};
p=0;
temp1=ones(2);
for i=1:numGaussians
    p=0;
    temp1=ones(2);
%Creating grid
for k=1:length(in)
        if (abs(xcomb(i,1)-in(k,1))<(dLat/2)) && (abs(xcomb(i,2)-in(k,2))<(dLong/2))
        p=p+1;
        temp1(p,:)=in(k,:) ;      
        end
temp{1,i}=temp1;
covar1{1,i} = cov(temp{1,i});
   % Fill your mean (mu) and variance (sig) here
    %===========================================%
    mu = mean(temp{1,i});
    sig=pinv(covar1{1,i});

end
    %===========================================%
    baseFuncs{i}=@(x)myGaussian(x,mu,sig);
    params.mu{i}=mu;
    params.sig{i}=sig;
end
baseFuncs{end}=@(x)1;
%calculate the values of each basis function at each training datapoint
val=zeros(length(in),length(baseFuncs));
parfor i=1:length(in)
    valTemp=zeros(1,length(baseFuncs));
    for j=1:length(baseFuncs)
        valTemp(1,j)=baseFuncs{j}(in(i,:));
    end
    val(i,:)=valTemp;
end
%pseudoinverse for least squares solution
params.w=pinv(val)*out;
params.baseFuncs=baseFuncs;
end

function val=myGaussian(x,mu,sig)
%a gaussian basis function
val=exp(-(x-mu)*sig*(x-mu)');
end

