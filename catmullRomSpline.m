function C = catmullRomSpline(controlPoints)
    % CATMULLROMSPLINE  Generates a Catmull-Rom spline
    % from the provided control points.
    %
    % C = CATMULLROMSPLINE(controlPoints) Returns an array of points
    % that follow the path of the Catmull-Rom spline specified by the
    % control points.
    %
    % See https://en.wikipedia.org/wiki/Centripetal_Catmull%E2%80%93Rom_spline
    % for more information.
    
    if ~isfloat(controlPoints)
        error('Control points must be a numeric array');
    end

    numControlPoints = size(controlPoints, 1);
    controlPointDimensions = size(controlPoints, 2);
    numSamplesPerSpline = 100;
    
    if numControlPoints < 4
        error('There must be at least 4 control points');
    end
    
    if numControlPoints > 4
        % A Catmull-Rom spline is typically defined by 4 control points.
        % In this case, multiple splines will be generated and then
        % combined into a single spline that will be returned
        
        numSplines = numControlPoints-3;
        
        C = zeros(numSamplesPerSpline*numSplines, controlPointDimensions);
        for i=1:numSplines
            spline = catmullRomSpline(controlPoints(i:i+3, :));
            
            stopIndex = i * numSamplesPerSpline;
            startIndex = stopIndex - numSamplesPerSpline + 1;
                        
            C(startIndex:stopIndex, :) = spline;
        end
    end
    if numControlPoints == 4
        P0 = controlPoints(1, :);
        P1 = controlPoints(2, :);
        P2 = controlPoints(3, :);
        P3 = controlPoints(4, :);

        t0 = 0;
        t1 = tj(t0, P0, P1);
        t2 = tj(t1, P1, P2);
        t3 = tj(t2, P2, P3);
        
        % Generate evenly spaced points between t1 and t2
        % transposed to allow multiplication by control points
        t = linspace(t1, t2, numSamplesPerSpline)';

        A1 = (t1-t)/(t1-t0)*P0 + (t-t0)/(t1-t0)*P1;
        A2 = (t2-t)/(t2-t1)*P1 + (t-t1)/(t2-t1)*P2;
        A3 = (t3-t)/(t3-t2)*P2 + (t-t2)/(t3-t2)*P3;

        B1 = (t2-t)/(t2-t0).*A1 + (t-t0)/(t2-t0).*A2;
        B2 = (t3-t)/(t3-t1).*A2 + (t-t1)/(t3-t1).*A3;

        C  = (t2-t)/(t2-t1).*B1 + (t-t1)/(t2-t1).*B2;
    end
end