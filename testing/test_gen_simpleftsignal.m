% testing gen_simpleftsignal

clear all,

addpath('/Users/mark/Dropbox/tACS_project_matlab_code/fieldtrip-20130901');
addpath(genpath('/Users/mark/Dropbox/tacs_project_matlab_code/functions'));
ft_defaults;


session_path = '/Users/mark/Dropbox/tACS_project_matlab_code/exampleData/subject_BL_desynch001';

[params, rest1_eeg, pre_stim_eeg, post_dur_stim_eeg, rest2_eeg, log_path] =...
    initialize(session_path);
load(params);

%%
% testing on pre-stim data

fsample = params.Recording.SamplingRate;
trllength = params.Task.Trial(params.Task.TrialCount.PreStimTrials).Timing.TrialEnd; % in s
numtrl = 1; % continuous data

[simplesignal] = gen_simpleftsignal(fsample,trllength,...
    numtrl);