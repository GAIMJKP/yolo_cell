if exist('yolonet')~=1
    load('M:\NIH\Code_M3\Code_Jamey\YOLO\yolonet.mat')
end

lgraph = layerGraph(yolonet.Layers);
lgraph = removeLayers(lgraph,'softmax');
lgraph = removeLayers(lgraph,'ClassificationLayer');

% fcWeights = zeros(147,4096);
% fcBias = zeros(147,1);
inputlayer = imageInputLayer([448 448 3],'Name','ImageInputLayer');
fclayer = fullyConnectedLayer(147,'Name','FullyConnectedLayer1');
fclayer.Weights = single(randn([147 4096]) * 0.0001);
fclayer.Bias = single(randn([147 1]) * 0.0001);


alayer = leakyReluLayer('Name','linear_25','Scale',0);
rlayer = regressionLayer('Name','routput');
lgraph = addLayers(lgraph,rlayer);
lgraph = replaceLayer(lgraph,'ImageInputLayer',inputlayer);
lgraph = replaceLayer(lgraph,'FullyConnectedLayer1',fclayer);
%lgraph = replaceLayer(lgraph,'leakyrelu_25',alayer);
lgraph = connectLayers(lgraph,'FullyConnectedLayer1','routput');
%yolojb_cell = assembleNetwork(lgraph);

save yolojb_cell_input_norm lgraph
