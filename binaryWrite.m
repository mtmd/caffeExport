function  binaryWrite(fileName, matrix)
fileId = fopen(fileName, 'w');
fwrite(fileId, matrix, 'float');
fclose(fileId);
end

