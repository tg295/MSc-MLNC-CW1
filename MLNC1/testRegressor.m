%% Theo Bacon Gardner, CID: 1439118
function [ val ] = testRegressor(in, params)
val=zeros(length(in),1);
baseFuncs=params.baseFuncs;
w=params.w;
%calculate values of all testing datapoints
parfor i=1:length(in)
    for j=1:length(baseFuncs)
        val(i)=val(i)+w(j)*baseFuncs{j}(in(i,:));
    end
end
end

