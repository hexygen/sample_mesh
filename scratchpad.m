%%
pts = importdata('../data/shapes/cube20k.xyz');
[~,d] = knnsearch(pts,pts,'K',2);
disp(mean(d(:,2)));
% 0.0086 mean nearest neighbor distance for cube20k (this is used as
% standard deviation for the gaussian noise in the paper of Boulch et al.)

%%
pts_noisy = pts + normrnd(0,0.0086,size(pts));

figure;
hold on;
scatter3(pts_noisy(:,1),pts_noisy(:,2),pts_noisy(:,3),'.','SizeData',200);
axis equal;
hold off;

%%
pts1 = importdata('../../data/temp/cube100k.xyz');
% pts2 = importdata('../data/temp/cube100k_noise_brown_1.00e-01.xyz');
% pts2 = importdata('../data/temp/cube100k_noise_brown_5.00e-02.xyz');
% pts2 = importdata('../data/temp/cube100k_noise_brown_1.00e-02.xyz');
% pts2 = importdata('../../data/shapes/cube100k_noise_white_1.00e-02.xyz');
% pts2 = importdata('../../data/shapes/cube100k_noise_white_5.00e-02.xyz');
pts2 = importdata('../../data/shapes/cube100k_noise_white_1.00e-01.xyz');
d = sqrt(sum((pts1-pts2).^2,2)); % since the seed was fixed, corresponding points have same indices
disp(sqrt(mean(d.^2)));
% 0.0239 error standard deviation (euclidean distance) for cube 100k with 0.1 brown noise
% 0.0120 error standard deviation (euclidean distance) for cube 100k with 0.05 brown noise
% 0.0024 error standard deviation (euclidean distance) for cube 100k with 0.01 brown noise

%% save to PLY for poisson reconstruction

outname = '../data/dragon100k_st.ply';

pts = importdata('../data/shapes/dragon100k.xyz');
% nrm = importdata('../data/results/t012/boxunion100k.normals');
nrm = importdata('../data/shapes/dragon100k.normals');

pc_filename = [tempname,'.ply'];

pcloud = pointCloud(pts,'Normal',nrm);
pcwrite(pcloud,pc_filename);

% [s,out] = system(['"../poissonrec/PoissonRecon.exe" --in "',pc_filename,'" --out "',outname,'" --depth 10']);
[s,out] = system(['"../poissonrec/SurfaceTrimmer.exe" --in "',pc_filename,'" --out "',outname,'" --trim 7']);
disp(out);

%%
temp = read_off_shape('../data/dragon100k_pr.off');
ab = temp.vertices(temp.faces(:,2),:) - temp.vertices(temp.faces(:,1),:);
ac = temp.vertices(temp.faces(:,3),:) - temp.vertices(temp.faces(:,1),:);

areas = sqrt(sum(cross(ab',ac').^2,1))./2;
