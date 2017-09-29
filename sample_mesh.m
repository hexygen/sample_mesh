function [points, map, normals, curvatures] = sample_mesh(vertices, faces, n, use_curvature)
% Samples n points on a mesh given by vertices and faces.
% points = the x,y,z positions of sampled points.
% map = for each point the closest vertex on the mesh, for evaluation purpose.

if (nargin < 4)
    use_curvature = 0;
end;

areas = computeArea(vertices, faces);

cum_areas = cumsum(areas);
% cum_areas = cum_areas - cum_areas(1);
cum_areas = [0;cum_areas ./ cum_areas(end)];

if (use_curvature)
    FV.faces = faces;
    FV.vertices = vertices;
    get_derivatives = 0;
%     [PrincipalCurvatures,PrincipalDir1,PrincipalDir2,FaceCMatrix,VertexCMatrix,Cmagnitude]= GetCurvatures( FV ,getderivatives);
    [PrincipalCurvatures]= GetCurvatures( FV ,get_derivatives);
    PrincipalCurvatures = PrincipalCurvatures';
end;

points = zeros(n, 3);
map = zeros(n, 1);
normals = zeros(n, 3);
curvatures = zeros(n, 2);

for i=1:n
    % Choose face by area:
    r = rand;
    faceind = binarysearch(cum_areas,r(1));
    v = faces(faceind,:);
    va = vertices(v(1),:);
    vb = vertices(v(2),:);
    vc = vertices(v(3),:);
    
    
    % Choose position on vertex:
    rx = rand;
    ry = rand;
    
    ra = (1-sqrt(rx));
    rb = sqrt(rx)*(1-ry);
    rc = sqrt(rx)*ry;
    
    p = ra*va + rb*vb + rc*vc;
    %p = (1-sqrt(rx))*faces(index1,1) + sqrt(rx)*(1-ry)*faces(index1,2) + sqrt(rx)*ry*faces(index1,3);
    points(i, :) = p;
    
    if (use_curvature)
        % Vertex Curvatures:
        cva = PrincipalCurvatures(v(1), :);
        cvb = PrincipalCurvatures(v(2), :);
        cvc = PrincipalCurvatures(v(3), :);
        
        % These are vectors with two values (k1 and k2):
        cv = ra*cva + rb*cvb + rc*cvc;
        curvatures(i, :) = cv;
    end;
    
    % Finding the closest vertex on the shape:
    if (ra > rb && ra > rc)
        map(i, :) = v(1);
    elseif (rb > rc)
        map(i, :) = v(2);
    else
        map(i, :) = v(3);
    end
    
    % Computing vertex normal:
    nn = cross(vb - va, vc - va);
    % normalize normal:
    nn = nn / norm(nn);
%     % orient it such that the most significant value is always positive:
%     if (max(abs(nn)) ~= max(nn))
%         nn = -nn;
%     end
    
    normals(i, :) = nn;
end


end