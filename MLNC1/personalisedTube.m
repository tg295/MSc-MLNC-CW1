function [TubeStop, TubeCoor] = personalisedTube(CID)
    try
        Tube = evalin('base', 'Tube');
    catch
        disp('Please load data first!')
        return
    end
    CID_str = num2str(CID);
    x = str2num(CID_str(end-1));
    y = str2num(CID_str(end));
    echo on
    idx = (x+5)*(y+7)+4;
    TubeStop = Tube.station{idx};
    TubeCoor = Tube.location(idx,:);
    disp(['Your home tube stop is ', TubeStop])
    disp(['Your home tube location is ', '[',num2str(TubeCoor), ']'])
    %disp(Tube.stationNames(idx))
    echo off
end