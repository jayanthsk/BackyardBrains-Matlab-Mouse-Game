function X_hat = runKalmanForward(A, W, H, Q, Y, Xo)

%X_hat = runKalmanForward_filledIn(A, W, H, Q, Y, Xo)
%
%Function to predict state X_hat from measured data Y using a Kalman Filter
%model specified by parameters [A, W, H, Q]. 
%
%input: A - state-transition matrix for the KF [#states x #states];
%       W - state-transition covariance matrix [#states x #states];
%       H - observation model matrix [#observations x #states];
%       Q - observation model covariance matrix [#observations x #observations];
%       Y - Observation data (e.g. spike firing rates) [#observations x time]
%       Xo - initial state (i.e. state at t=0) [#states x 1];
%
%outputs: X_hat - predicted states (e.g. hand kinematics) [#states x time]
%

%get # states, time-points, and observations from input matrices. 
[N_obs, N_time] = size(Y);
N_states = size(A,1);


%initialize matrices to store estimates
X_hat    = zeros(N_states, N_time);            %predicted state
X_hatAP  = zeros(N_states, N_time);            %a-priori estimates of state
P_AP     = zeros(N_states, N_states, N_time);  %apropri estimates of covariance. Note this initializes X_hat covariance to zero
P        = zeros(N_states, N_states, N_time);  %a-posterior estimate of covariance. 
K        = zeros(N_states, N_obs, N_time);     %kalman gain

X_hat(:,1) = Xo;  %initialize X_hat to last observed state
        

%loop through time
progCnt = 1; %counter to display progress estimates. 
for k=2:N_time
    
    
    if k/N_time*100 >= progCnt*10
        fprintf('%g\n', progCnt*10)
        progCnt = progCnt+1;
    end
    
    %a priori estimate of x ( X(k|k-1) = A*X(k-1) )
    X_hatAP(:,k) = A*X_hat(:,k-1); %FILLIN
    
    %a priori estimate of x covariance ( P(k) = A*P(k-1)*A' + W )
    P_AP(:,:,k) = A*P(:,:,k-1)*A' + W; %FILLIN
    
    %compute Kalman gain ( K = P_ap*H' * inv(H*P_ap*H' + Q) )
    K(:,:,k) = P_AP(:,:,k)*H' * pinv(H*P_AP(:,:,k)*H' + Q); %FILLIN
    
    %compute a posteriori estimate of x (X(k) = X(k|k-1) + K*(Y - H*X(k|k-1))
    X_hat(:,k) = X_hatAP(:,k) + K(:,:,k)*(Y(:,k) - H*X_hatAP(:,k)); %FILLIN
    
    %update covariance (a posteriori estimate, P = (I - K*H)*P_ap )
    P(:,:,k) = ( eye(N_states) - K(:,:,k)*H)*P_AP(:,:,k); %FILLIN
end
