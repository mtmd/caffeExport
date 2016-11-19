function [] = rotate1X1(binPath, vecPath, name, i, l, k, j)
fileID = fopen(strcat(binPath, '/', name));
A = fread(fileID, 'float');
AA = zeros(i * l * k * j, 1);
counter = 1;
for ii = 0:(i - 1)
    for ll = 0:(l - 1)
        for kk = 0:(k - 1)
            for jj = 0:(j - 1)
                AA(counter) = A(kk + ll * k + jj * l * k + ii * l * k * j + 1);
                counter = counter + 1;
            end
        end
    end
end
binaryWrite(strcat(vecPath, '/', name), AA);
fclose(fileID);
end

