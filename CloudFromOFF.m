function [ S ] = CloudFromOFF(offpath, np, savename, noise_strength, noise_color)
% CLOUDFROMOFF Reads an OFF file and produces a uniformly sampled point
% cloud.
%
% offpath = path to off file
% np = number of points to sample
% savename = file name to save point cloud (as .xyz)
% noise = amount of noise to add
% noise_color = 'color' (spatial frequency spectrum) of the noise

if nargin < 4 || isempty(noise_strength)
    noise_strength = 0;
end
if nargin < 5 || isempty(noise_color)
    noise_color = 'white';
end

% S = read_off_shape(offpath);
S = struct;
[S.vertices,S.faces] = readoffmesh(offpath);
S.nv = size(S.vertices,1);

[S.PCD, S.pcd_map, S.normals] = sample_mesh(S.vertices, S.faces, np);

% Add noise:
if strcmp(noise_color,'white')
    S.PCD = S.PCD + (rand(size(S.PCD))-1/2) .* (noise_strength * (max(max(S.PCD,[],1)-min(S.PCD,[],1))));
elseif strcmp(noise_color,'red') || strcmp(noise_color,'brown') || strcmp(noise_color,'brownian')
    maxval = 0.001;
    noise_sample_budget = 500^3; % 500^3 resolution needs about 11-13 gb of memory
    bbox_min = min(S.PCD,[],1);
    bbox_max = max(S.PCD,[],1);
    bbox_size = bbox_max - bbox_min;
    noise_res = round((noise_sample_budget .* [...
        bbox_size(1)^2 / (bbox_size(2)*bbox_size(3)); ...
        bbox_size(2)^2 / (bbox_size(1)*bbox_size(3)); ...
        bbox_size(3)^2 / (bbox_size(1)*bbox_size(2))]).^(1/3));
    noise = zeros(size(S.PCD));
    noise_interpolant = griddedInterpolant({...
        linspace(bbox_min(1),bbox_max(1),noise_res(1)),...
        linspace(bbox_min(2),bbox_max(2),noise_res(2)),...
        linspace(bbox_min(3),bbox_max(3),noise_res(3))},...
        colored_noise(noise_res',-2,0.03),'linear','nearest'); 
    noise(:,1) = noise_interpolant(S.PCD);
    noise_interpolant.Values = colored_noise(noise_res',-2,0.03);
    noise(:,2) = noise_interpolant(S.PCD);
    noise_interpolant.Values = colored_noise(noise_res',-2,0.03);
    noise(:,3) = noise_interpolant(S.PCD);
    noise = noise .* ((noise_strength/maxval) * (max(max(S.PCD,[],1)-min(S.PCD,[],1))));
    
    S.PCD = S.PCD + noise;
else
    error('Unknown noise color.')
end



% S.surface.X = S.PCD(:, 1);
% S.surface.Y = S.PCD(:, 2);
% S.surface.Z = S.PCD(:, 3);
% S.surface.nv = length(S.surface.X);

% Save xyz file:
if (nargin >= 3 && ~isempty(savename))
%     xyz = S.PCD;
%     save(savename, 'xyz', '-ascii');
    dlmwrite([savename '.xyz'], S.PCD, 'precision', '%.6f', 'delimiter', ' ');
    dlmwrite([savename '.normals'], S.normals, 'precision', '%.6f', 'delimiter', ' ');
end

end

