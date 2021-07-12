
% New water level requirements

repmat(start_level,[1 1 1 length(Indices_of_T_vector)]) + repmat(reshape([0:5:Horizon]'+rho*Level_calculation_matrix*Scenarios(:,iterate_subproblem),[1 1 1 length(Indices_of_T_vector)]),[N_segments 1 1 1]).*repmat(beta_vector,[1 1 1 length(Indices_of_T_vector)]);

% Nonanticipativity constraints

x(:,:,Indices_of_T_vector < Eq_constraints(iterate_subproblem),iterate_subproblem) == x(:,:,Indices_of_T_vector < Eq_constraints(iterate_subproblem+1),iterate_subproblem+1) ;
v(:,:,Indices_of_T_vector < Eq_constraints(iterate_subproblem),iterate_subproblem) == v(:,:,Indices_of_T_vector < Eq_constraints(iterate_subproblem+1),iterate_subproblem+1) ;
w(:,:,Indices_of_T_vector(2:length(Indices_of_T_vector)) < Eq_constraints(iterate_subproblem),iterate_subproblem) == w(:,:,Indices_of_T_vector(2:length(Indices_of_T_vector))  < Eq_constraints(iterate_subproblem+1),iterate_subproblem+1);
z(:,:,Indices_of_T_vector(2:length(Indices_of_T_vector)) < Eq_constraints(iterate_subproblem),iterate_subproblem) == z(:,:,Indices_of_T_vector(2:length(Indices_of_T_vector))  < Eq_constraints(iterate_subproblem+1),iterate_subproblem+1);

