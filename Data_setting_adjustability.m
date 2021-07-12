
% How deep do the splits go?

rho = 0.2;

Split_depth = 10;
Eq_constraints = [];
Scenarios = [];
Probabilities = ones(2^(Split_depth/10),1)/2^(Split_depth/10);
Nb_of_subproblems = 2^(Split_depth/10);

for iterate_scenario=0:2^(Split_depth/10)-1
    
    % Manipulations to get the coordinates
    vec = dec2base(iterate_scenario,2);
    vec = strcat(repmat('0',[1,(Split_depth/10)-length(vec)]),vec);
    Positions= abs(vec)'-48;
    
    % Setting the relevant demand scenario value
    Scenarios(:,iterate_scenario+1) = [Positions];
    
end

Scenarios = [ones(1,size(Scenarios,2)) ; Scenarios ; zeros((Horizon/10)-Split_depth/10,size(Scenarios,2)) ]; 

for iterate_scenario=0:2^(Split_depth/10)-1
    
    if(iterate_scenario>0)
        for i=1:(Split_depth/10)+1
            % Condition that if the first i outcomes of a scenario are the
            % same, then the corresponding decision vectors should be the
            % same up to time i+1
            if(prod(double(Scenarios(1:i,iterate_scenario)==Scenarios(1:i,iterate_scenario+1))) > 0)
                Eq_constraints(iterate_scenario) = i*10;
            end
        end
    end
    
end

Scenarios = 1- Scenarios(2:Horizon/10+1,:);


Level_calculation_matrix = zeros(length(Indices_of_T_vector),Horizon/10);

for iterate_T_period = 1:length(Indices_of_T_vector)
    
    for iterate_Horizon_interval = 1:Horizon/10
    
        Level_calculation_matrix(iterate_T_period,iterate_Horizon_interval) = 10*(Indices_of_T_vector(iterate_T_period)-1 >= iterate_Horizon_interval*10) + 5*(Indices_of_T_vector(iterate_T_period)-1 > (iterate_Horizon_interval-1)*10)*(Indices_of_T_vector(iterate_T_period) -1 < (iterate_Horizon_interval)*10);
    
    end
    
end

