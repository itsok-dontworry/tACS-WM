function [params_path, rest1_eeg_path, pre_stim_eeg_path, post_dur_stim_eeg_path, rest2_eeg,...
    log_path] = init_session(session_path)
%INITIALIZE Initializes analysis of a session.
% Return params and eeg file-paths when done succesfully. Additionally, a
% log folder is created. It will contain all steps of processed data
% (filering etc.).
%
% SYNOPSIS
%   [params, rest1_eeg, pre_stim_eeg, post_dur_stim_eeg, rest2_eeg, log_path] = init_session(session_folder)
%
% INPUT
%   (string)  session_path: path to folder that contains the parameter file  (as .mat) and all EEG files (rest1, pre_stim, post_stim, rest2 at .dat)
%
% OUPUT
%   (string)  params_path:                    path to params file
%   (string)  rest1_eeg_path:                 path to rest 1 EEG file
%   (string)  pre_stim_eeg_path:            path to pre-stim EEG file
%   (string)  post_dur_stim_eeg_path:    path to post/during-stim EEG file
%   (string)  rest2_eeg_path:                 path to rest 2 EEG file
%   (string)  log_path                            path to logfile

% get subject ID
folder      = session_path(strfind(session_path, 'subject_'):end);
localize    = strfind(folder,'_');
subjectID     = folder(localize(1)+1:localize(2)-1);
log_path    = [session_path filesep 'log'];

condition   = '';
% find out what session we are looking at, by looking for _<condition> in
% the folders name (the subject name can be drawn from the folders
% name, too)
if (strfind(session_path,'_synch'))
    condition = 'synch';
elseif (strfind(session_path,'_desynch'))
    condition = 'desynch';
elseif (strfind(session_path,'_sham'))
    condition = 'sham';
% wrong folder    
else 
    error('Wrong folder');
end

% the following three files are essential to analyse the session. their
% filenames consist of subject and condition as follows
params_path              = [session_path filesep 'subject' '_' subjectID,'_',condition,'.mat'];
rest1_eeg_path           = [session_path filesep 'subject' '_' subjectID,'_',condition,'S001R01.dat'];
pre_stim_eeg_path        = [session_path filesep 'subject' '_' subjectID,'_',condition,'S001R02.dat'];
post_dur_stim_eeg_path   = [session_path filesep 'subject' '_' subjectID,'_',condition,'S001R03.dat'];
rest2_eeg           = [session_path filesep 'subject' '_' subjectID,'_',condition,'S001R04.dat'];

% check for log file and delete if exists
mkdir(log_path);
if(exist([log_path filesep 'log.txt']))
    delete([log_path filesep 'log.txt']);
end
% check whether all objects exist
if(exist(params_path, 'file') && exist(pre_stim_eeg_path, 'file') && ...
        exist(post_dur_stim_eeg_path, 'file') && exist(rest1_eeg_path, 'file') ...
        && exist(rest2_eeg, 'file'))
    % create log folder
    write_to_log(log_path, ['successfully initialized session ', '"', condition, '"', ' for subject ', '"', subjectID, '"']);
    success = true;
else
    write_to_log(log_path, ['files missing in session ', '"', condition, '"', ' for subject ', '"', subjectID, '"']);
    success = false;

% now that everything is in place, the preprocessing can begin
end

