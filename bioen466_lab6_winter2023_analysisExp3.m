
%%%%% This script provides a guided outline for analyzing your experimental data collected
%%%%% for Experiment 3 (quantifying task performance in a closed-loop EMG OR Voice interface)
%%%%% Written by A.L. Orsborn, v200216, v210220
%%%%%
%%%%%
%%%%% All lines where you have to fill in information is tagged with a comment including "FILLIN". Use this flag to find everything you need to modify.
%%%%% all figures that need to be included in comprehension questions are
%%%%% flagged with %INCLUDE THIS FIGURE IN COMPREHENSION QUESTIONS

% we will first load a data file and test our pre-processing and calculations on one file. Once that is complete, we can extend our analysis to all data to examine trends.
%% Cell 1: defining constants

%define task constants
CENTER_ON_CODE = 1;
ENTER_CENTER_CODE = 2;
GOCUE_CODE = 3;
ENTER_TARGET_CODE = 5;
SUCCESS_CODE = 6;
FAIL_CODE = 7;

TARG_CODE_OFFSET = 10;
REACH_TIMEOUT_ERROR_CODE = 8;
CENTER_HOLD_ERROR_CODE = 9;
TARGET_HOLD_ERROR_CODE = 10;

%% Cell 2: Load an example file and run task metric calculations

% Define some basic things to make it easy to find your data files.
% We will want to take advantage of systematic naming structure in our data files.
% Your files should have names like [prefix][date][id #].
% Note that our program automatically saves files with date and time in the name.
% We recommend re-naming your files to convert time into a simpler id# e.g. 1, 2, 3...

dataDir = ''; %FILLIN: the path to where your data is stored

file_prefix = 'EMG_1D_centerOut_vel_01-Mar-2023 '; %FILLIN: the text string that is common among all your data files
file_type = '.mat';   %FILLIN: the file extension for your data type

file_date   = ['16.47.44'; '16.57.51'; '17.00.49'; '17.03.52'; '17.12.47']; %FILLIN: the date string used in your file

ste_reach_time = zeros(4, 1);
mean_reach_time = zeros(4, 1);
percent_correct = zeros(4, 1);

for i=1:size(file_date,1)

    full_file_name = [dataDir file_prefix file_date(i, :) file_type];

    % num2str(file_idnum)
    
    %load the task events and event-times from file
    load(full_file_name, 'task_events', 'task_event_times');
    
    %trial-sort your events
    %align to 'ENTER_CENTER_CODE' to find all possible trial errors (center
    %hold, target hold error, reach time-out error)
    align_code = ENTER_CENTER_CODE; %FILLIN
    num_events_before = 1;
    num_events_after = 4;
    [trial_events, trial_event_times] = trialAlignEvents(task_events, task_event_times, align_code, num_events_before, num_events_after); %FILLIN (look at function help)
    
    
    %%%%% compute the % successful trials
    trial_success = trial_events == SUCCESS_CODE; %FILLIN: make a vector that = 1 when SUCCESS_CODE happens within a trial (0 otherwise)
    trial_fail    = trial_events == FAIL_CODE; %FILLIN: make a vector that = 1 when FAIL_CODE happens within a trial (0 otherwise)
    
    
    %sanity check that a trial is only successful or failed
    all = trial_success + trial_fail;
    if  ~isempty(all(all == 2))%FILLIN: write a one-lie way to check if a trial is flagged as both successful and failed (we want the error message to show if that happens)
        error('Task trial processing is not correct')
    end
    
    percent_correct(i, 1) = length(trial_success(trial_success)) / (length(trial_success(trial_success)) + length(trial_fail(trial_fail))); %FILLIN: compute percent correct: 100*(# successes)/(total # trials)
    
    %%%%%%
    
    %%%%% compute the reach time (= time enter target - go cue)
    
    num_trials = size(trial_success,1); %number of trials
    reach_time = nan(num_trials,1); %initialize reach_time vector [#trials x 1]
    
    for j=1:num_trials %loop through trials
        
        %look for each task event within the trial
        idx_go    = find(trial_events(j, :) == GOCUE_CODE); %FILLIN: find index when go-cue happens on trial i
        idx_enter = find(trial_events(j, :) == ENTER_TARGET_CODE); %FILLIN: find index when and enters target on trial i
        
        %Both events may not happen in a trial, so only compute reach time if
        %they happen. Otherwise, reach time is not defined
        if  ~isempty(idx_go) && ~isempty(idx_enter) %FILLIN: write a logical statement that is only true when idx_go and idx_enter are found
            q = trial_event_times(trial_events(j, :) == idx_enter);
            v = trial_event_times(trial_events(j, :) == idx_go);
            reach_time(j) = q - v; %FILLIN: use trial_event_times and the computed indices to compute the reach time for this trial
        end
    end
    
    %calculate the mean and standard error of reach time
    %recall that reach_time can be a nan. Look at the help for 'nanmean'
    mean_reach_time(i, 1) = mean(reach_time, 'omitnan'); %FILLIN: compute mean
    ste_reach_time(i, 1) = std(reach_time, 'omitnan')/sqrt(length(reach_time)); %FILLIN: compute standard error (std/sqrt(# measurements))
end

%% cell 3: Now we will load the data for all files, compute metrics, and make plots


% write code to turn the above computation into a loop. You will want to:
% 1) define a list of files to load and associated metadata (e.g. lag)
% 2) Loop over files:
%      load file(i)
%      trial-sort task_events and task_event_times
%      compute percent_correct(i)
%      compute mean_reach_time(i) and ste_reach_time(i)
% 3) Make plots of:
%      percent_correct vs. loop lag %INCLUDE THIS FIGURE IN COMPREHENSION QUESTIONS
%      mean_reach_time vs. loop lag (with error-bars showing the ste) %INCLUDE THIS FIGURE IN COMPREHENSION QUESTIONS
%      percent_correct vs. control variable (position vs. velocity) %INCLUDE THIS FIGURE IN COMPREHENSION QUESTIONS
%      mean_reach_time vs. control variable (with error-bars showing the ste) %INCLUDE THIS FIGURE IN COMPREHENSION QUESTIONS

figure
plot(percent_correct(2:4, 1))
xticks(1:3)
xticklabels({'500','300','100'})
xlabel("Lag time (ms)")
ylabel("Percent Correct")
title("Percent Correct vs Lagtime (ms)")

figure
errorbar(mean_reach_time(2:4), ste_reach_time(2:4))
xticks(1:3)
xticklabels({'500','300','100'})
xlabel("Lag time (ms)")
ylabel("Mean Reach Time")
title("Mean Reach Time vs lag time(ms)")

figure
plot([percent_correct(1) percent_correct(5)])
xticks(1:2)
xticklabels({'velocity','position'})
xlabel("Control Variable")
ylabel("Percent Correct")
title("Percent Correct vs Type of Control")

figure
errorbar([mean_reach_time(1) mean_reach_time(5)], [ste_reach_time(1) ste_reach_time(5)])
xticks(1:2)
xticklabels({'velocity','position'})
xlabel("Control Variable")
ylabel("Mean Reach Time")
title("Mean reach time vs type of control")