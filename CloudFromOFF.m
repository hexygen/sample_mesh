function [ S ] = CloudFromOFF( offpath, np, noise, savename )
% CLOUDFROMOFF Reads an OFF file and produces a uniformly sampled point
% cloud.
%
% offpath = path to off file
% np = number of points to sample
% noise = amount of noise to add
% savename = file name to save point cloud (as .xyz)

% S = read_off_shape(offpath);
S = struct;
[S.vertices,S.faces] = readoffmesh(offpath);
S.nv = size(S.vertices,1);

[S.PCD, S.pcd_map, S.normals] = sample_mesh(S.vertices, S.faces, np);
% Add noise:
S.PCD = S.PCD + noise*(rand(size(S.PCD))-1/2)*(max(max(S.PCD)-min(S.PCD)));

% S.surface.X = S.PCD(:, 1);
% S.surface.Y = S.PCD(:, 2);
% S.surface.Z = S.PCD(:, 3);
% S.surface.nv = length(S.surface.X);

% Save xyz file:
if (nargin > 3 && ~isempty(savename))
%     xyz = S.PCD;
%     save(savename, 'xyz', '-ascii');
    dlmwrite([savename '.xyz'], S.PCD, 'precision', '%.6f', 'delimiter', ' ');
    dlmwrite([savename '.normals'], S.normals, 'precision', '%.6f', 'delimiter', ' ');
end

end

