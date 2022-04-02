
classdef World < handle
   
    properties (SetAccess = immutable)
        Cpm  (1,1) double {mustBePositive} = 1
        Mpc  (1,1) double {mustBePositive} = 1
        Ofst (1,1) double {mustBePositive} = 1
        Y, X (1,1) double {mustBeInteger, mustBePositive} = 1
        H, W (1,1) double {mustBePositive} = 1
    end

    properties (SetAccess = private)
        Map (:,:) logical {} = []
        Grd (:,:) double  {} = [] % complex double
        pts  (:,2) double {mustBeNonnegative} = []
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
            W.Grd = zeros(W.Y, W.X);
        end
        

        function setRegion(W, y, x, h, w, vl)
            arguments
                W       (1,1) World   {}
                y,x,h,w (1,1) double  {mustBeNonnegative}
                vl      (1,1) logical {}
            end
            ym = W.h2yf(y);
            yM = W.h2yc(y+h-1/W.Cpm);
            xm = W.w2xf(x);
            xM = W.w2xc(x+w-1/W.Cpm);
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

            invalid = find(W.Map == 1);
            W.Grd(invalid) = NaN;
            [ys, xs] = find(W.Map == 0);
            
%             wallMap = W.Map;
            wallMap = W.Map & ~imerode(W.Map, strel("square", 3));

%             d0 = (euclDist(0, 0, mRds, 0) + euclDist(0, 0, 0, mRds))/2
            d0 = mRds;

            for i = 1:length(ys)
                x0 = xs(i);
                y0 = ys(i);
                ttlGrd = 0 + 0i;

                for yi = (y0-cRds):(y0+cRds)
                    for xi = (x0-cRds):(x0+cRds)
%                       if yi ~= W.yb(yi) && xi ~= W.yb(xi) || yi == W.yb(yi) && xi == W.yb(xi) && wallMap(yi, xi)
                        if yi ~= W.yb(yi) || xi ~= W.yb(xi) || wallMap(yi, xi)
                            dst = W.c2m(euclDist(yi, xi, y0, x0));
                            ttlGrd = ttlGrd + W.c2m(cplxDist(yi, xi, y0, x0)) / dst^2 * max(1/dst - 1/d0, 0);
                        end
                    end
                end
                W.Grd(y0, x0) = ttlGrd + W.c2m(cplxDist(y0, x0, W.h2yr(fPos(1)), W.h2yr(fPos(2)))) / W.c2m(euclDist(y0, x0, W.h2yr(fPos(1)), W.h2yr(fPos(2))));
            end
        end


        function showTerrain(W)
            image([W.Ofst, W.W-W.Ofst], [W.Ofst, W.H-W.Ofst], ~W.Map)
            colormap(gray(2))

            set(gca,'YDir','normal')
            axis equal

            ylim([0, W.H])
            xlim([0, W.W])
            
            title("Terrain")
            ylabel("Length (0-"+string(W.H)+" m) ("+string(W.Y)+"c)")
            xlabel("Width  (0-"+string(W.W)+" m) ("+string(W.X)+"c)")
        end

        function showPotential(W)
            Ptn = abs(W.Grd);
            Ptn(isnan(Ptn)) = Inf;

            cM = max(Ptn(~isinf(Ptn)));
            cm = min(Ptn(~isinf(Ptn)));
            if (~isnan(cm) && ~isnan(cM))
                caxis([cm, cM]);
            end

            cMap = interp1([0; 0.5; 1], [0 1 0; 1 1 0; 1 0 0], linspace(0, 1, 100), 'linear');
            imagesc([W.Ofst, W.W-W.Ofst], [W.Ofst, W.H-W.Ofst], Ptn)

            colormap(cMap)
            colorbar

            set(gca, 'YDir', 'normal')
            axis equal

            ylim([0, W.H])
            xlim([0, W.W])
            
            title("Potential")
            ylabel("Length (0-"+string(W.H)+" m) ("+string(W.Y)+"c)")
            xlabel("Width  (0-"+string(W.W)+" m) ("+string(W.X)+"c)")
        end

        function showVectors(W)
            vctrs = W.Grd;
%             vctrs = vctrs ./ abs(vctrs);
            quiver(linspace(W.Ofst, W.W-W.Ofst, W.X), linspace(W.Ofst, W.H-W.Ofst, W.Y), real(vctrs), imag(vctrs), 2) % +W.ofst

            axis equal

            ylim([0, W.H])
            xlim([0, W.W])
            
            title("Vectors")
            ylabel("Length (0-"+string(W.H)+" m) ("+string(W.Y)+"c)")
            xlabel("Width  (0-"+string(W.W)+" m) ("+string(W.X)+"c)")
        end
        
        function showCar(W)

            initialpos = [W.H W.W]/2;
            finalpos = [W.H W.W];

            W.pts = finalpos;

            orientation = 0;
            position = [initialpos orientation]';
            
            % robot definition
            robot = differentialDriveKinematics("TrackWidth", 1, "VehicleInputs", "VehicleSpeedHeadingRate");
            
            %Create the path following controller
            control = controllerPurePursuit; %definicja
            control.Waypoints = W.pts; %transitions
            control.DesiredLinearVelocity = W.H/10;
            control.MaxAngularVelocity = 2;
            control.LookaheadDistance = 0.3;
            
            error = 1; %threshold
            distance = norm(initialpos - finalpos);
            
            T = 0.1;
            freq = rateControl(1/T); %frequency of loop execution
            
            robotsize = robot.TrackWidth/0.9; %space needed for robot
            
            plot(W.pts(:,1), W.pts(:,2), "*r");

            while( distance > error ) %change into number of coordinates in matrix points
                
                [v1, angle] = control(position); %data about robot in current position
                v = derivative(robot, position, [v1 angle]); %velocity of robot
            
                %update position
                position = position + v*T; 
                %update distnace
                distance = norm(position(1:2) - finalpos(:));
                
%                 hold off
%                 world.showTerrain();
%                 hold on
                
                %plot 
                plotTrVec = [position(1:2); 0];
                plotRot = axang2quat([0 0 1 position(3)]);
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
            m = c/W.Cpm;
        end

        function y = h2yr(W, h)
            y = round(h*W.Cpm) + 1;
            y = W.yb(y);
        end
        function x = w2xr(W, w)
            x = round(w*W.Cpm) + 1;
            x = W.xb(x);
        end
        
        function y = h2yc(W, h)
            y = ceil(h*W.Cpm) + 1;
            y = W.yb(y);
        end
        function x = w2xc(W, w)
            x = ceil(w*W.Cpm) + 1;
            x = W.xb(x);
        end
        
        function y = h2yf(W, h)
            y = floor(h*W.Cpm) + 1;
            y = W.yb(y);
        end
        function x = w2xf(W, w)
            x = floor(w*W.Cpm) + 1;
            x = W.xb(x);
        end
        
        function x = xb(W, x)
            x = min(max(x, 1), W.X);
        end
        function y = yb(W, y)
            y = min(max(y, 1), W.Y);
        end
    end

end


function dist = euclDist(y1, x1, y2, x2)
    dist = sqrt( (y2-y1)^2 + (x2-x1)^2 );
end

function dist = cplxDist(y1, x1, y2, x2)
    dist = (x2-x1) + 1i* (y2-y1);
end

