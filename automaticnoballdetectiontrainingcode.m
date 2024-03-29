%% Create and Train a Deep Learning Model
% Script for creating and training a deep learning network with the following 
% properties:
%%
% 
%  Number of layers: 7
%  Number of connections: 6
%  Training setup file: /Users/apurvaaddula/Desktop/trainingSetup_2020_11_02__19_08_14.mat
%
%% 
% Run this script to create the network layers, import training and validation 
% data, and train the network. The network layers are stored in the workspace 
% variable |layers|. The trained network is stored in the workspace variable |net|.
% 
% To learn more, see <matlab:helpview('deeplearning','generate_matlab_code') 
% Generate MATLAB Code From Deep Network Designer>.
% 
% Auto-generated by MATLAB on 02-Nov-2020 19:08:17
%% Load Initial Parameters
% Load parameters for network initialization. For transfer learning, the network 
% initialization parameters are the parameters of the initial pretrained network.

trainingSetup = load("/Users/apurvaaddula/Desktop/trainingSetup_2020_11_02__19_08_14.mat");
%% Import Data
% Import training and validation data.

imdsTrain = imageDatastore("/Users/apurvaaddula/Desktop/DATASET","IncludeSubfolders",true,"LabelSource","foldernames");
[imdsTrain, imdsValidation] = splitEachLabel(imdsTrain,0.7,"randomized");
%% Augmentation Settings

imageAugmenter = imageDataAugmenter(...
    "RandRotation",[-360 360],...
    "RandScale",[1 2],...
    "RandXReflection",true);

% Resize the images to match the network input layer.
augimdsTrain = augmentedImageDatastore([28 28 3],imdsTrain,"DataAugmentation",imageAugmenter);
augimdsValidation = augmentedImageDatastore([28 28 3],imdsValidation);
%% Set Training Options
% Specify options to use when training.

opts = trainingOptions("sgdm",...
    "ExecutionEnvironment","auto",...
    "InitialLearnRate",0.01,...
    "MaxEpochs",5,...
    "Shuffle","every-epoch",...
    "Plots","training-progress",...
    "ValidationData",augimdsValidation);
%% Create Array of Layers

layers = [
    imageInputLayer([28 28 3],"Name","imageinput")
    convolution2dLayer([3 3],32,"Name","conv","Padding","same")
    batchNormalizationLayer("Name","batchnorm")
    reluLayer("Name","relu")
    fullyConnectedLayer(2,"Name","fc")
    softmaxLayer("Name","softmax")
    classificationLayer("Name","classoutput")];
%% Train Network
% Train the network using the specified options and training data.

[net, traininfo] = trainNetwork(augimdsTrain,layers,opts);