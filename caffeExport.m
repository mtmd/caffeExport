function caffeExport()
clc;
caffePath = '';     %Path to the caffe installation folder
defFile = '';       %Address of the network definition file
modelFile = '';     %Address of the network model file
outputPath = '';    %The folder in which the output is supposed to be saved
params = 0;         %If param = 1, network parameters (weights) will be extracted
intermed = 0;       %If intermed = 1, intermediate results will be extraced
inputFile = '';     %Sample input image for which we want to extract 
                    %intermediate results. If intermed = 0, this value is
                    %not requried. 
meanFile = '';      %Path to the mean file of the dataset
%%
% Reading the config file.
fileId = fopen('Config.txt');
if (fileId == -1)
    error('Cannot find config.txt in the current directory');
end
line = fgets(fileId);
while (ischar(line)) 
    tokens = strsplit(line, '=');
    if (line(1) == '#')
        line = fgets(fileId);
        continue;
    end
    switch(strtrim(tokens{1}))
        case 'caffe_path'
            caffePath = strtrim(tokens{2});
        case 'def_file'
            defFile = strtrim(tokens{2});
        case 'model_file'
            modelFile = strtrim(tokens{2});
        case 'output_path'
            outputPath = strtrim(tokens{2});
        case 'net_params'
            params = (strtrim(tokens{2}) == '1');
        case 'intermediate_results'
            intermed = (strtrim(tokens{2}) == '1');
        case 'input_file'
            inputFile = strtrim(tokens{2});
        case 'mean_file'
            meanFile = strtrim(tokens{2});
    end
    line = fgets(fileId);
end
fclose(fileId);
%%
% Setting up caffe parameters
if (params == 0 && intermed == 0)
    return;
end
addpath(caffePath);
caffe.set_mode_cpu();
net = caffe.Net(defFile, modelFile, 'test');
net.blobs('data').reshape([227 227 3 1]); % reshape blob 'data'
net.reshape();
%%
% Dumping Parameters
if (params)
    %Values will be saved both as mat and binary files. 
    matPath = strcat(outputPath, '/', 'Parameters/Normal/MAT');
    binPath = strcat(outputPath, '/', 'Parameters/Normal/Binary');
    if (exist(binPath, 'dir') == 0)
        mkdir(binPath);
    end    
    if (exist(matPath, 'dir') == 0)    
        mkdir(matPath)
    end
    numLayers = size(net.layer_names, 1);
    for i = 1:numLayers
        blobName = net.layer_names{i};
        convolution = 0;
        if (strcmp(net.layers(blobName).type, 'Convolution') || ...
            strcmp(net.layers(blobName).type, 'InnerProduct'))
            if strcmp(net.layers(blobName).type, 'Convolution') 
                convolution = 1;
            end
            weights = net.params(blobName, 1).get_data();
            bias = net.params(blobName, 2).get_data();
            blobName = strrep(blobName, '/', '_');
            blobName = strrep(blobName, '\', '_');
            % Writes values as .mat files.
            save (strcat(matPath ,'/', blobName, '_w.mat'), 'weights');
            save (strcat(matPath , '/', blobName, '_b.mat'), 'bias');
            % Writes parameters as a binary file (float values)
            if (convolution)
                weights = permute(weights, [2 1 3 4]);
            end
            binaryWrite(strcat(binPath, '/', blobName, '_w.bin'), weights);
            binaryWrite(strcat(binPath, '/', blobName, '_b.bin'), bias);
        end
    end
    % Generate Vectorized Parameters. 
    vecPath = strcat(outputPath, '/', 'Parameters/Vectorized/Binary');
    if (exist(vecPath, 'dir') == 0)
        mkdir(vecPath);
    end  
    vectorize (matPath, binPath, vecPath);
    % End Generating Vectorized Parameters
end
%%
% Dumping Intermediate Results
matPath = strcat(outputPath, '/', 'Intermediate_Results/MAT');
if (exist(matPath, 'dir') == 0)    
    mkdir(matPath)
end
tokens = strsplit(inputFile, '.');
sz = size(tokens, 2);
copyfile(inputFile, strcat(matPath, '/', 'originalInput.', tokens{sz}));
img = preproc(inputFile, meanFile);
net.forward({img});
numBlobs = size(net.blob_names, 1);
for i = 1:numBlobs
    blobName = net.blob_names{i};
    data = net.blobs(blobName).get_data();
    blobName = strrep(blobName, '/', '_');
    blobName = strrep(blobName, '\', '_');
    if (intermed)
        save (strcat(matPath, '/', num2str(i), '_', blobName, '.mat'), 'data');
    end
    if (strcmp(blobName, 'data'))
        data = permute(data, [2 1 3]);
        binaryWrite(strcat(binPath, '/', blobName, '.bin'), data);
        if (intermed == 0) 
            break;
        end
    end
end
end

