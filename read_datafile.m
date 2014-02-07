function [raw_data, dat_info] = read_datafile(file_path ,params, log_path)
%READ_DATAFILE Read data from .dat-file and assign channel labels. Leave
%data as a single trial.
%
% SYNOPSIS
%   [raw_data dat_info] = read_datafile(file_path,params,log_path)
%
% INPUT
%   (string) log_path:   path to log file
%   (string) file_path:  path to the file to be read
%   (string) params:     params file
%
% OUTPUT
%   (struct) raw_data:   loaded data with channel labels.
%   (struct) dat_info: struct containig important information like record
%   etc.
%

if(nargin<3)
    log_path = pwd;
end

dat_info = [];

cfg = [];
cfg.dataset = file_path;
% determine the type of recording (i.e. rest1, prestim etc...)
record_code = file_path(strfind(file_path, 'R0'):1:strfind(file_path, 'R0')+2);
switch(record_code)
    case 'R01'
        record = 'rest1';
    case 'R02'
        record = 'pre_stim';
    case 'R03'
        record = 'dur_post_stim';
    case 'R04'
        record = 'rest2';
    otherwise
        error('Wrong record_code');
end
dat_info.record = record; % NOTE: really bad idea to use the cfg to save data
dat_info.params = params;

cfg.trialfun = @(cfg) trialfun_param_events(cfg,dat_info); % one trial, all events

cfg = ft_definetrial(cfg);
write_to_log(log_path, ['succesfully read events from ', file_path]);
cfg.continuous = 'yes';


raw_data = ft_preprocessing(cfg);
write_to_log(log_path, ['succesfully read data from ', file_path]);

% set channel names in data
raw_data.label = {'Fp1','Fp2', ...
    'F7','F3','Fz','F4','F8', ... 
    'FC5','FC1','FC2','FC6', ...
    'T7','C3','Cz','C4','T8', ...
    'TP9', ...
    'CP5','CP1','CP2','CP6','TP10', ...
    'P7','P3','Pz','P4','P8', ...
    'PO9','O1','Oz','O2','PO10', ...
    'AF7','AF3','AF4','AF8', ...
    'F5','F1','F2','F6', ...
    'FT9','FT7','FC3','FC4','FT8','FT10', ...
    'C5','C1','C2','C6', ...
    'TP7','CP3','CPz','CP4','TP8', ...
    'P5','P1','P2','P6', ...
    'PO7','PO3','POz','PO4','PO8', ...
    'EOG', ...
    'APBleft', 'APBright', ...
    ''};

end