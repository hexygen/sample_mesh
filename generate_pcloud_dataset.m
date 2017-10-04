point_count = 100000;

source_dir = '../data/shape_sources';
shape_dir = '../data/shapes';

shape_names = {'dragon_xyzrgb'};
% shape_names = {...
%     'boxunion_uniform',...
%     'fandisk',...
%     'bunny',...
%     'armadillo',...
%     'cube_uniform',...
%     'cube_subdiv1',...
%     'cube_subdiv2'};
%     'happy',...
%     'dragon'};

noise_type = 'white';
min_noise = 0;
max_noise = 0.1;
noise_level_count = 11;

for s = 1:numel(shape_names)
    shape_name = shape_names{s};
    
    disp(['shape: ',shape_name])
    
    for noise_level=linspace(min_noise,max_noise,noise_level_count)
        
        disp(['    noise level: ',num2str(noise_level)]);

        source_filename = fullfile(source_dir,[shape_name,'.off']);
        shape_filename = fullfile(shape_dir,[shape_name,sprintf('%d',round(point_count/1000)),'k']);

        if noise_level == 0
            CloudFromOFF(source_filename ,point_count,shape_filename);
        else
            shape_filename = [shape_filename,'_noise_',noise_type,sprintf('_%.2e',noise_level)]; %#ok<AGROW>
            CloudFromOFF(source_filename ,point_count,shape_filename,noise_level,noise_type);
        end
        disp(['    generated file: ',shape_filename]);
    end
end
