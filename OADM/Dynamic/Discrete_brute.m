clear all
clc

vls = [0, 1, 2, 3, 4, 5]*50
prfts = transpose([0 0 0 0; 17 25 20 30; 38 40 35 45; 50 48 52 50; 55 56 60 55; 60 62 68 68])
maxprofit = 0;
count = 0;

for u0 = 1:length(vls)
    for u1 = 1:length(vls)
        for u2 = 1:length(vls)
            for u3 = 1:length(vls)
                if vls(u0)+vls(u1)+vls(u2)+vls(u3) <= 300
                    profit = prfts(1,u0)+prfts(2,u1)+prfts(3,u2)+prfts(4,u3);
                    if profit > maxprofit
                        clc
                        count = 1;
                        maxprofit = profit;
                        u = [vls(u0), vls(u1), vls(u2), vls(u3)]
                    elseif profit == maxprofit
                        count = count+1;
                        u = [vls(u0), vls(u1), vls(u2), vls(u3)]
                    end
                end
            end
        end
    end
end

count
maxprofit
