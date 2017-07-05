%% point clouds without noise
% CloudFromOFF('../data/shapes/sources/cube.off',100000,'../data/shapes/cube',0);
% CloudFromOFF('../data/shapes/sources/fandisk.off',100000,'../data/shapes/fandisk100k',0);
% CloudFromOFF('../data/shapes/sources/bunny.off',100000,'../data/shapes/bunny100k');
% CloudFromOFF('../data/shapes/sources/armadillo.off',100000,'../data/shapes/armadillo100k');
CloudFromOFF('../data/shapes/sources/dragon.off',100000,'../data/shapes/dragon100k');
CloudFromOFF('../data/shapes/sources/happy.off',100000,'../data/shapes/happy100k');

%% point clouds with brown noise
% CloudFromOFF('../data/shapes/sources/cube.off',100000,'../data/shapes/cube100k_noise_brown_3e-2',0.03,'brown');
% CloudFromOFF('../data/shapes/sources/fandisk.off',100000,'../data/shapes/fandisk100k_noise_brown_3e-2',0.03,'brown');
% CloudFromOFF('../data/shapes/sources/bunny.off',100000,'../data/shapes/bunny100k_noise_brown_3e-2',0.03,'brown');
% CloudFromOFF('../data/shapes/sources/armadillo.off',100000,'../data/shapes/armadillo100k_noise_brown_3e-2',0.03,'brown');
CloudFromOFF('../data/shapes/sources/dragon.off',100000,'../data/shapes/dragon100k_noise_brown_3e-2',0.03,'brown');
CloudFromOFF('../data/shapes/sources/happy.off',100000,'../data/shapes/happy100k_noise_brown_3e-2',0.03,'brown');

%%
% temp = colored_noise([1000,1000],-2,0.02);
temp = colored_noise([500,500,500],-2,0.03);

%%
figure;
% image(temp,'CDataMapping','scaled');
image(temp(:,:,2),'CDataMapping','scaled');