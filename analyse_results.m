%% INITIALIZE
clc
clear all
% define paths as global variables
% MAIN_PATH = 'D:\ThesisData';
MAIN_PATH = '/Volumes/Transcend/ThesisData';
% add fieldtrip path
addpath([MAIN_PATH filesep 'fieldtrip-20130901']);
RESULT_PATH = [MAIN_PATH filesep 'RESULTS'];
% add our functions
% FUNCTIONS_PATH = '\\ads.bris.ac.uk\filestore\MyFiles\Students\mo13924\Documents\GitHub\tACS-WM';
FUNCTIONS_PATH = [MAIN_PATH filesep 'functions'];
addpath(genpath(FUNCTIONS_PATH));
% apply fieldtrip general fieldtrip settings
ft_defaults;
% go to path
cd(FUNCTIONS_PATH);
DATA_PATH = [MAIN_PATH filesep 'EEG'];

%% LOAD AGAIN
subject_list = {'AF', 'AG', 'ArG', 'AT', 'BL', 'CS', 'DZ', 'FG',...
    'ML', 'NP', 'SG', 'SP', 'VS', 'YM'};
N = length(subject_list);
datlist = cell(N,6);

for i = 1:N
    subjectID = subject_list{i};
    lis = dir([RESULT_PATH filesep subjectID filesep '*_result.mat']);
    for j = 1:6
        % forgot to save condition, do it now
        idx = strfind(lis(j).name, '_');
        condition = lis(j).name(idx(1)+1:idx(2)-1);
        % record seems to be wrong as well
        datlist{i,j} = importdata([RESULT_PATH filesep subjectID filesep lis(j).name]);
        datlist{i,j}.condition = condition;
        fprintf('.');
    end
end

%% IDEA
% calc mean for 200-400ms and 5-7 hz
% compare to pre

%% Lists of data
desynch_list_post = datlist(cellfun(@(x) strcmp(x.condition, 'desynch') ...
                                && strcmp(x.record, 'dur_post_stim'), ...
                                datlist));
desynch_list_post = [desynch_list_post{:,1}];	

synch_list_post = datlist(cellfun(@(x) strcmp(x.condition, 'synch') ...
                       && strcmp(x.record, 'dur_post_stim'), ...
                                datlist));
synch_list_post = [synch_list_post{:,1}];

sham_list_post = datlist(cellfun(@(x) strcmp(x.condition, 'sham') ...
                                && strcmp(x.record, 'dur_post_stim'), ...
                                datlist));
sham_list_post = [sham_list_post{:,1}];

desynch_list_pre = datlist(cellfun(@(x) strcmp(x.condition, 'desynch') ...
                                && strcmp(x.record, 'pre_stim'), ...
                                datlist));
desynch_list_pre = [desynch_list_pre{:,1}];		

synch_list_pre = datlist(cellfun(@(x) strcmp(x.condition, 'synch') ...
                       && strcmp(x.record, 'pre_stim'), ...
                                datlist));
synch_list_pre = [synch_list_pre{:,1}];							
sham_list_pre = datlist(cellfun(@(x) strcmp(x.condition, 'sham') ...
                                && strcmp(x.record, 'pre_stim'), ...
                                datlist));
sham_list_pre  = [sham_list_pre{:,1}];	


%% try stats

mean_desynch_pre = cell2mat(arrayfun(@(x)(mean(mean(squeeze(x.wpli.wpli_debiasedspctrm(1,:,:))))), desynch_list_pre,'UniformOutput', 0));
mean_sham_pre = cell2mat(arrayfun(@(x)(mean(mean(squeeze(x.wpli.wpli_debiasedspctrm(1,:,:))))), sham_list_pre,'UniformOutput', 0));
mean_synch_pre = cell2mat(arrayfun(@(x)(mean(mean(squeeze(x.wpli.wpli_debiasedspctrm(1,:,:))))), synch_list_pre,'UniformOutput', 0));


mean_desynch_post = cell2mat(arrayfun(@(x)(mean(mean(squeeze(x.wpli.wpli_debiasedspctrm(1,:,:))))), desynch_list_post,'UniformOutput', 0));
mean_sham_post = cell2mat(arrayfun(@(x)(mean(mean(squeeze(x.wpli.wpli_debiasedspctrm(1,:,:))))), sham_list_post,'UniformOutput', 0));
mean_synch_post = cell2mat(arrayfun(@(x)(mean(mean(squeeze(x.wpli.wpli_debiasedspctrm(1,:,:))))), synch_list_post,'UniformOutput', 0));



% scatter plot
% post
figure, hold on
scatter(2*ones(length(mean_desynch_post),1), mean_desynch_post)
scatter(ones(length(mean_sham_post),1), mean_sham_post)
scatter(0*ones(length(mean_synch_post),1), mean_synch_post)
title('post');

% post - pre
figure, hold on
scatter(2*ones(length(mean_desynch_post - mean_desynch_pre),1), mean_desynch_post - mean_desynch_pre)
scatter(ones(length(mean_sham_post - mean_sham_pre),1), mean_sham_post - mean_sham_pre)
scatter(0*ones(length(mean_synch_post - mean_synch_pre),1), mean_synch_post - mean_synch_pre)
title('post - pre');

%% ANOVA
sham = [mean_sham_pre', mean_sham_post'];
synch = [mean_synch_pre', mean_synch_post'];
desynch = [mean_desynch_pre', mean_desynch_post'];
[p, table] = anova_rm({synch, sham, desynch});


%% PLOTS
% only post list
figure, title('desynch_post')
for i = 1:14
    subplot(2,7,i);
    wpli = desynch_list_post(i).wpli;
    surf(wpli.time, wpli.freq, ...
         squeeze(wpli.wpli_debiasedspctrm(1,:,:)),'edgecolor','none');
    axis tight;
    xlabel(desynch_list_post(i).ID); ylabel('Hz');
    view(2);
end

figure, title('synch_post')
for i = 1:14
    subplot(2,7,i);
    wpli = synch_list_post(i).wpli;
    surf(wpli.time, wpli.freq, ...
         squeeze(wpli.wpli_debiasedspctrm(1,:,:)),'edgecolor','none');
    axis tight;
    xlabel('Time'); ylabel('Hz');
    view(2);
end
%% plot mean wpli
desynch_mean = mean(cat(4,desynch_list(:).wpli), 4);
sham_mean = mean(cat(4,sham_list(:).wpli), 4);
synch_mean = mean(cat(4,synch_list(:).wpli), 4);

figure
subplot(3,1,1);
title('desynch');
surf(desynch_list(i).time, sham_list(i).freq, squeeze(desynch_mean(1,:,:)), ...
     'edgecolor','none');
    xlabel('Time'); ylabel('Hz');
    view(2);
    caxis([0 0.3]);
    colorbar
subplot(3,1,2);
title('sham');
surf(sham_list(i).time, sham_list(i).freq, squeeze(sham_mean(1,:,:)), ...
     'edgecolor','none');
    xlabel('Time'); ylabel('Hz');
    view(2);
    colorbar
    caxis([0 0.3]);
subplot(3,1,3);
title('synch');
surf(synch_list(i).time, sham_list(i).freq, squeeze(synch_mean(1,:,:)), ...
     'edgecolor','none');
xlabel('Time'); ylabel('Hz');
view(2);
colorbar
caxis([0 0.3]);

