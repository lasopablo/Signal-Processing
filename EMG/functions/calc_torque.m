function tau_c = calc_torque(W_sbj,H_sbj,theta,load,sit) % checked
% EMG_signal_processing.m complementary

L_fore= 0.146*H_sbj;
L_hand= 0.106*H_sbj;
M_fore= 0.016*W_sbj;
M_hand= 0.006*W_sbj;

CoM_fore= 0.43*L_fore;
CoM_hand= 0.506*L_hand;

CoM_FH= (M_fore*CoM_fore+M_hand*(L_fore+CoM_hand))/(M_fore+M_hand);

M_FH = M_fore+M_hand;

g=9.81;
M_b = 5; % mass of grasped object

if sit % sit=1
    if load 
        % 2 section in paper
        tau_c= -(M_FH*g*CoM_FH+M_b*g*(L_fore+L_hand/2))*cos(theta);
    else
        tau_c= -(M_FH*g*CoM_FH)*cos(theta);
    end
else
    if load
        tau_c= (M_FH*g*CoM_FH+M_b*g*(L_fore+L_hand/2))*sin(theta);
    else
        tau_c= (M_FH*g*CoM_FH)*cos(theta);
    end
end