function fltrd_data =  OT_filter(state_samples,measured_output,cost,weight,OT_constants)
    % Inputs: X_init_OT,obs_states(j,:)',cost,weight,OT_constantshdl
    M = size(state_samples,2);
    [Aeq,Aeq_1] = OT_constants(M);
    P = Optimal_Transport(state_samples,measured_output,cost,Aeq,Aeq_1,weight);
    % Inputs: X_f,Y,cost,Aeq,Aeq_1,weight
    fltrd_data = state_samples*P;
end