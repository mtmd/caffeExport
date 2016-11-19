function [] = vectorize (matPath, binPath, vecPath)
    listing = dir(matPath);
    for i = 3: size(listing, 1)
        %disp(listing(i).name);
        a = load(strcat(matPath, '/', listing(i).name));
        binName = listing(i).name;
        binName = strrep(binName, '.mat', '.bin');
        
        if (strcmp(fieldnames(a), 'weights')) 
            sz = size(a.weights);
            if (numel(sz) == 4)
                if sz(3) == 3
                    rotate(binPath, vecPath, binName, sz(4), sz(1), sz(2), 4);
                elseif sz(2)== 1
                    rotate1X1(binPath, vecPath, binName, sz(4), sz(1), sz(2), sz(3));
                else
                    genericRotate(binPath, vecPath, binName, sz(4), sz(1), sz(2), sz(3));
                end
            end
        end
    end
end