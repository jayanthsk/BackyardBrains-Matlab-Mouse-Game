%%%%% This script provides an outline for implementing real-time EMG streaming
%%%%% and plotting for lab6 experiment 1a

%%%%% Written by A.L. Orsborn, v200216, v210220
%%%%%
%%%%%
%%%%% All lines where you have to fill in information is tagged with a comment including "FILLIN". Use this flag to find everything you need to modify.
%%%%% all figures that need to be included in comprehension questions are
%%%%% flagged with %INCLUDE THIS FIGURE IN COMPREHENSION QUESTIONS


%% cell 1: defining constants, setting up workspace

%loop time-interval (i.e. bin-size)
DELTA_T = 0.1;

RUN_LENGTH  = floor(1*60*10/DELTA_T); %time to run loop in samples
PLOT_LENGTH = floor(1*30/DELTA_T); %time duration to plot in samples

NUM_CHANNELS = 2; %# channels streaming


%base matlab directory on your computer
%(where you installed streaming utility software)
MATLAB_DIR = 'C:\Users\jayan\Documents\MATLAB'; %FILLIN

addpath(genpath(MATLAB_DIR)) %add those tools to the path

LOOP_TIME_FF = 0.001; %'fudge factor' for loop time 


%% cell 2: Real-time loop


%initialize variables
emg_inputs   = zeros(NUM_CHANNELS, RUN_LENGTH); %FILLIN. streamed emg inputs, [# channels x time you will run your loop]
elapsed_time = nan(RUN_LENGTH, 1); %FILLIN. time it takes loop to execute [time you will run your loop x 1]
emg_plot     = zeros(NUM_CHANNELS, PLOT_LENGTH); %FILLIN: running buffer for data to plot, [# channels x time points you will plot]


%%%% initialize your data socket via lab-streaming-layer
%this is provided in full. nothing to do here, but look at what this does. 
disp('Initializing data socket...')
lib = lsl_loadlib(); 
streams = lsl_resolve_all(lib);
info = streams{1};
inlet = lsl_inlet(info);
inlet.set_postprocessing(15);
inlet.pull_chunk() % The first call to pull_chunk is always empty.
% Pull whatever's available to clear the buffer
for i = 1:10
    [data_chunk,stamps] = inlet.pull_chunk();
end
disp('...done!')
%%%%%%% done initializing socket. 


figure %create a figure to plot our streamed data on
ax_emg = subplot(1, 3, 1:2); %axis for plotting our emg
ax_hist = subplot(1, 3, 3);  %axis for plotting histogram of loop execution times

HIST_BINS = 0:1:200; %bins for histogram plots. 
time_plot = linspace(0, PLOT_LENGTH*DELTA_T, PLOT_LENGTH); %time-axis for EMG plot

%loop over time your loop will run. 
for i=1:RUN_LENGTH%FILLIN

    %start a clock to keep track of time at this moment in the loop.
    %set this variable to 't0'
    %hint: look at matlab help for 'clock'
    %FILLIN (1 line) 
    t0 = clock;
    
    %pull latest data from your buffer
    %store EMG data as 'data_chunk' and time-stamps as 'stamps'
    %hint: look at how we did this above when we cleared the buffer.
    %data_chunk should be [NUM_CHANNELS #time-samples pulled in]
    %stamps should be [1 #time-samples pulled in]
    %FILLIN (1 line)
    [data_chunk,stamps] = inlet.pull_chunk();
    
    %update 'emg_inputs' for this loop iteration 
    %we will visualize the mean(|EMG|) for each channel.  
    emg_inputs(:,i) = mean(data_chunk, 2); %FILLIN
      
    
    %now update emg_plot and time_plot to be a rolling buffer of data for our plot
    %1. time-shift the data by 1 (move all elements LEFT by 1)
    %    hint: look at matlab help for 'circshift'
    emg_plot  = circshift(emg_plot, -1, 2); %FILLIN
    
    %2. put the new data at the end of emg_plot and time_plot
    emg_plot(:,end) = emg_inputs(:, i); %FILLIN
    
    
    %plot our data
    %1. plot time_plot vs. emg_plot on the axis we made for EMG
    %   hint: look at help for 'plot' to see how to pass in the axis handle 'ax_emg')
    plot(ax_emg, time_plot, emg_plot, 'linewidth', 2.5) %FILLIN []s with appropriate arguments to pass in
    
    %2. plot a histogram of elapsed_time on the axis we made for a
    %histogram, using HIST_BINS bins. 
    %hint: look at the help for 'histogram'. 
    %(note: we haven't updated elapsed_time yet so our histogram will lag
    %behind by 1. Why am I not plotting after we compute the elapsed time? Think about
    %the loop structure.)
    histogram(ax_hist, elapsed_time, HIST_BINS, 'Normalization', 'probability'); %FILLIN []s with appropriate arguments to pass in
    
    drawnow %this command forces matlab to push updates to the figure NOW (rather than after our code finishes running)
    
    
    %use 'pause' to make our loop execute every DELTA_T seconds
    %We must wait (DELTA_T - LOOP_TIME_FF) - (time our loop took to execute)
    % hint: look at the help for 'etime'
    pause(DELTA_T - LOOP_TIME_FF - etime(clock, t0)); %FILLIN
    
    %store total execution time of our loop in ms (NOT SECONDS)
    elapsed_time(i) = 1000 * etime(clock, t0); %FILLIN
end

%INCLUDE THIS FIGURE IN COMPREHENSION QUESTIONS
%be sure to grab a snap-shot of your generated figure as you stream data. 
