function sanityCheck(trainRegressor,testRegressor)

dummyGPS = [rand(10,1)+51, rand(10,1)];
dummyRent = [rand(10, 1)*10000];

assert(fopen('testRegressor.m') > 0,'Could not find testRegressor.m function file')
assert(fopen('trainRegressor.m') > 0,'Could not find trainRegressor.m function file')
assert(nargin(trainRegressor) == 2, 'Number of inputs for training function should equal 2.')
assert(nargout(trainRegressor) == 1, 'There should only be one output for your training function.')
assert(nargin(testRegressor) == 2, 'Number of inputs for training function should equal 2.')
assert(nargout(testRegressor) == 1, 'There should only be one output for your training function.')

try
    dummyoutput = trainRegressor(dummyGPS, dummyRent);
catch
    warning('Wrong input format.')
    return
end

assert(isnumeric(dummyoutput) || isstruct(dummyoutput), 'Output is not valid. Must be matrix or structure.')

try 
    dummyoutput = testRegressor(dummyGPS, dummyoutput);
catch
    warning('Wrong input format.')
    return
end

assert(size(dummyoutput,1) ==1 || size(dummyoutput,2) == 1, 'Output is not valid. Must be a single column.')

disp('Congratulations! Sanity check passed')

end

