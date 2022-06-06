
classdef World < handle
   
    properties (Constant = true, GetAccess = private)
        BWmap = gray(2);
        GYRmap = interp1([0; 0.5; 1], [0 1 0; 1 1 0; 1 0 0], linspace(0, 1, 100), 'linear');
    end

    properties (SetAccess = immutable)
        Cpm  (1,1) double {mustBePositive} = 1
        Mpc  (1,1) double {mustBePositive} = 1
        Ofst (1,1) double {mustBePositive} = 1
        Y, X (1,1) double {mustBeInteger, mustBePositive} = 1
        H, W (1,1) double {mustBePositive} = 1
    end
    
    properties (SetAccess = private)
        Map (:,:) logical {} = []
        Frc (:,:) double  {} = [] % complex double
        Nav (:,:) double  {} = [] % complex double
        Grd (:,:) double  {} = [] % complex double

        Pth (:,2) double {mustBeNonnegative} = []
    end
    
    methods
        function W = World(Hm, Wm, CPM)
            arguments
                Hm, Wm (1,1) double {mustBePositive} = 10
                CPM    (1,1) double {mustBePositive} = 1
            end
            W.Cpm = CPM;
            W.Mpc = 1/CPM;
            W.Ofst = (0.5) * W.Mpc; %  (0.5) | (0.5 - 1e-12)

            W.Y = ceil(Hm*CPM);
            W.X = ceil(Wm*CPM);
            W.H = W.Y / CPM;
            W.W = W.X / CPM;

            W.Map = zeros(W.Y, W.X);
            W.Frc = zeros(W.Y, W.X);
            W.Nav = zeros(W.Y, W.X);
            W.Grd = zeros(W.Y, W.X);
        end
        
        function setRegion(W, y, x, h, w, vl)
            arguments
                W       (1,1) World   {}
                y,x,h,w (1,1) double  {mustBeNonnegative}
                vl      (1,1) logical {}
            end
            ym = W.h2y(y);
            yM = W.h2yc(y+h-W.Mpc);
            xm = W.w2x(x);
            xM = W.w2xc(x+w-W.Mpc);
            W.Map(ym:yM, xm:xM) = vl;
            
%             fprintf("%i:%i\t; %i:%i\n", ym, yM, xm, xM);
        end
        
        
        function genForces(W, mRds, fPos)
            arguments
                W    (1,1) World  {}
                mRds (1,1) double {mustBeNonnegative} = 3
                fPos (1,2) double {mustBeNonnegative} = [W.H, W.W]/2
            end

            cRds = ceil(mRds * W.Cpm);

            invalid = find(W.Map);
            W.Frc(invalid) = NaN;
            [ys, xs] = find(~W.Map);
            
%             wallMap = W.Map;
            wallMap = W.Map & ~imerode(W.Map, strel("square", 3));

            d0 = mRds;

            for i = 1:length(ys)
                x0 = xs(i);
                y0 = ys(i);
                ttlGrd = 0 + 0i;

                for yi = (y0-cRds):(y0+cRds)
                    for xi = (x0-cRds):(x0+cRds)
%                       if yi ~= W.yb(yi) && xi ~= W.yb(xi) || yi == W.yb(yi) && xi == W.yb(xi) && wallMap(yi, xi)
                        if yi ~= W.yb(yi) || xi ~= W.yb(xi) || wallMap(yi, xi)
                            dstc = W.c2m(cplxDist(yi, xi, y0, x0));
                            dste = abs(dstc);
                            ttlGrd = ttlGrd + dstc / dste^2 * max(1/dste - 1/d0, 0);
                        end
                    end
                end
                dstc = cplxDist(W.y2h(y0), W.x2w(x0), fPos(1), fPos(2));
                dste = abs(dstc);
                W.Frc(y0, x0) = ttlGrd + 5 * dstc * max(1/dste - 1/d0, 0) / dste^2;
            end

            W.genCombined();
        end
        
        function genNavigation(W, fPos)
            arguments
                W    (1,1) World  {}
                fPos (1,2) double {mustBeNonnegative} = [W.H, W.W]/2
            end

            [xs,ys] = meshgrid(-1:1, -1:1);
            Mask = xs + ys * 1i;
            Mask = Mask ./ abs(Mask);
            Mask(2,2) = 0;
%             Mask = [0 0 0; -1 0 1; 0 0 0] + [0 -1 0; 0 0 0; 0 1 0] * 1i;
            
            Old = false(W.Y, W.X);
            New = false(W.Y, W.X);
            New(W.h2y(fPos(1)), W.w2x(fPos(2))) = true;
            W.Nav = zeros(W.Y, W.X, 'double');
            
            while any(New, 'all')
                TempV = imfilter(double(Old), Mask, 0);
                
                nidx = find(New);
                W.Nav(nidx) = TempV(nidx);

                Old = Old | New;
                New = imdilate(Old, [0 1 0; 1 1 1; 0 1 0]) & ~Old & ~W.Map;
            end
            
            W.Nav = W.Nav ./ abs(W.Nav);

            W.genCombined();
        end

        function genCombined(W)
            arguments
                W    (1,1) World  {}
            end
            f = 0.5;
            W.Grd = (1-f) * fillmissing(W.Frc, "linear") + f * fillmissing(W.Nav, "linear");

            W.Grd = W.Grd ./ abs(W.Grd);

            invalid = find(isnan(W.Grd));
            W.Grd(invalid) = 0;
        end

        function genPath(W, sPos, fPos)
            arguments
                W    (1,1) World  {}
                sPos (1,2) double {mustBeNonnegative} = [W.H, W.W]/2
                fPos (1,2) double {mustBeNonnegative} = [W.H, W.W]/2
            end
            step = W.Mpc / 2;

            W.Pth = sPos;
            prevDir = 0;

            it = 0;

            while it < 500 && euclDist(sPos(1), sPos(2), fPos(1), fPos(2)) > step
                it = it + 1

                cuCl = [W.h2y(sPos(1)), W.w2x(sPos(2))];
                clCt = [W.y2h(cuCl(1)), W.x2w(cuCl(2))];

                wy = 1-W.m2c(abs(sPos(1)-clCt(1)));
                wx = 1-W.m2c(abs(sPos(2)-clCt(2)));
            
                currDir = W.Grd(W.yb(cuCl(1)), W.xb(cuCl(2)))*wy*wx;

                if sPos(1) >= clCt(1)
                    if sPos(2) >= clCt(2)
%                         disp('Y> , X>');
                        currDir = currDir + W.Grd(W.yb(cuCl(1)+1), W.xb(cuCl(2)+1))*(1-wy)*(1-wx) + W.Grd(W.yb(cuCl(1)+1), W.xb(cuCl(2)))*(1-wy)*wx + W.Grd(W.yb(cuCl(1)), W.xb(cuCl(2)+1))*wy*(1-wx);
                    else
%                         disp('Y> , X<');
                        currDir = currDir + W.Grd(W.yb(cuCl(1)+1), W.xb(cuCl(2)-1))*(1-wy)*(1-wx) + W.Grd(W.yb(cuCl(1)+1), W.xb(cuCl(2)))*(1-wy)*wx + W.Grd(W.yb(cuCl(1)), W.xb(cuCl(2)-1))*wy*(1-wx);
                    end
                else
                    if sPos(2) >= clCt(2)
%                         disp('Y< , X>');
                        currDir = currDir + W.Grd(W.yb(cuCl(1)-1), W.xb(cuCl(2)+1))*(1-wy)*(1-wx) + W.Grd(W.yb(cuCl(1)-1), W.xb(cuCl(2)))*(1-wy)*wx + W.Grd(W.yb(cuCl(1)), W.xb(cuCl(2)+1))*wy*(1-wx);
                    else
%                         disp('Y< , X<');
                        currDir = currDir + W.Grd(W.yb(cuCl(1)-1), W.xb(cuCl(2)-1))*(1-wy)*(1-wx) + W.Grd(W.yb(cuCl(1)-1), W.xb(cuCl(2)))*(1-wy)*wx + W.Grd(W.yb(cuCl(1)), W.xb(cuCl(2)-1))*wy*(1-wx);
                    end
                end

                if isnan(currDir) || abs(currDir) == 0
                    W.Pth = [W.Pth; sPos];
                    warning('Local minimum found!');
                    break;
                end

                if (currDir ~= prevDir)
                    W.Pth = [W.Pth; sPos];
                    prevDir = currDir;
                end

                sPos = sPos + step * [imag(currDir), real(currDir)];
                
            end
            W.Pth = [W.Pth; fPos];
        end


        function showTerrain(W)
            image([W.Ofst, W.W-W.Ofst], [W.Ofst, W.H-W.Ofst], ~W.Map)
            colormap(W.BWmap)
            
            for i = 1:W.Y-1
                line([0, W.W], [i, i]*W.Mpc, 'Color', 'k');
            end
            for i = 1:W.X-1
                line([i, i]*W.Mpc, [0, W.H], 'Color', 'k');
            end

            W.fixPlot();
            title("Terrain")
        end

        function showPotential(W)
            Ptn = abs(W.Frc);
            Ptn(isnan(Ptn)) = Inf;

            cM = max(Ptn(~isinf(Ptn)));
            cm = min(Ptn(~isinf(Ptn)));
            if (~isnan(cm) && ~isnan(cM))
                caxis([cm, cM]);
            end

            colormap(W.GYRmap)
            imagesc([W.Ofst, W.W-W.Ofst], [W.Ofst, W.H-W.Ofst], Ptn)
            colorbar
            W.fixPlot();
            title("Potential")
            
        end

        function showForces(W)
            quiver(linspace(W.Ofst, W.W-W.Ofst, W.X), linspace(W.Ofst, W.H-W.Ofst, W.Y), real(W.Frc), imag(W.Frc), 2) %  , "Alignment", "center" M2022a
            W.fixPlot();
            title("Forces")
        end

        function showNavigation(W)
            quiver(linspace(W.Ofst, W.W-W.Ofst, W.X), linspace(W.Ofst, W.H-W.Ofst, W.Y), real(W.Nav), imag(W.Nav), 0.5)
            W.fixPlot();
            title("Navigation")
        end

        function showCombined(W)
            quiver(linspace(W.Ofst, W.W-W.Ofst, W.X), linspace(W.Ofst, W.H-W.Ofst, W.Y), real(W.Grd), imag(W.Grd), 0.5)
            W.fixPlot();
            title("Combined")
        end
        
        function showPath(W)
            plot(W.Pth(1,2), W.Pth(1,1), "ro");
            plot(W.Pth(:,2), W.Pth(:,1), "r.--");
            plot(W.Pth(end,2), W.Pth(end,1), "rx");
            W.fixPlot();
            title("Path")
        end

        function showCar(W)

            finalPos = W.Pth(end,:);
            orientation = 0;
            currPos = [W.Pth(1,:), orientation]';
            
            % robot definition
            robot = differentialDriveKinematics("TrackWidth", 1, "VehicleInputs", "VehicleSpeedHeadingRate");
            
            %Create the path following controller
            control = controllerPurePursuit; %definicja
            control.Waypoints = W.Pth; %transitions
            control.DesiredLinearVelocity = W.H/10;
            control.MaxAngularVelocity = 2;
            control.LookaheadDistance = 0.3;
            
            error = 1; %threshold
            distance = norm(initialpos - finalPos);
            
            T = 0.1;
            freq = rateControl(1/T); %frequency of loop execution
            
            robotsize = robot.TrackWidth/0.9; %space needed for robot
            
            plot(W.Pth(:,1), W.Pth(:,2), "*r");

            while( distance > error ) %change into number of coordinates in matrix points
                
                [v1, angle] = control(currPos); %data about robot in current position
                v = derivative(robot, currPos, [v1 angle]); %velocity of robot
            
                %update position
                currPos = currPos + v*T; 
                %update distnace
                distance = norm(currPos(1:2) - finalPos(:));
                
%                 hold off
%                 world.showTerrain();
%                 hold on
                
                %plot 
                plotTrVec = [currPos(1:2); 0];
                plotRot = axang2quat([0 0 1 currPos(3)]);
                plotTransforms(plotTrVec', plotRot, "MeshFilePath", "groundvehicle.stl", "Parent", gca, "View","2D", "FrameSize", robotsize);
            %     light;
                xlim([0 W.H])
                ylim([0 W.W])
                
                waitfor(freq);
            end

        end

    end
    
    % meter and cell conversion functions
    methods (Access = private)

        function c = m2c(W, m)
            c = m*W.Cpm;
        end
        function m = c2m(W, c)
            m = c*W.Mpc;
        end
        
        function y = h2yc(W, h)
            y = ceil(h*W.Cpm) + 1;
            y = W.yb(y);
        end
        function x = w2xc(W, w)
            x = ceil(w*W.Cpm) + 1;
            x = W.xb(x);
        end
        
        function y = h2y(W, h)
            y = floor(h*W.Cpm) + 1;
            y = W.yb(y);
        end
        function x = w2x(W, w)
            x = floor(w*W.Cpm) + 1;
            x = W.xb(x);
        end
        
        function h = y2h(W, y)
            h = W.c2m(y-0.5);
        end
        function w = x2w(W, x)
            w = W.c2m(x-0.5);
        end

        function x = xb(W, x)
            x = min(max(x, 1), W.X);
        end
        function y = yb(W, y)
            y = min(max(y, 1), W.Y);
        end

        function fixPlot(W)
            set(gcf, 'Position', [500 300 1000 900])
            set(gca, 'YDir', 'normal')
            axis equal
            ylim([0, W.H])
            xlim([0, W.W])
            ylabel("Length (0-"+string(W.H)+" m) ("+string(W.Y)+"c)")
            xlabel("Width  (0-"+string(W.W)+" m) ("+string(W.X)+"c)")
        end
    end

end


function dist = euclDist(y1, x1, y2, x2)
    dist = sqrt( (y2-y1)^2 + (x2-x1)^2 );
end

function dist = cplxDist(y1, x1, y2, x2)
    dist = (x2-x1) + 1i* (y2-y1);
end

