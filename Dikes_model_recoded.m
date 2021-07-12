
% Declaring the dimensions

discount_factor = 0.055;

D = zeros(N_segments,N_d_measures,length(Indices_of_T_vector));

D = repmat(Dijkkosten,[1 1 length(Indices_of_T_vector)]).*repmat(reshape((1+discount_factor).^[1-Indices_of_T_vector],[1 1 length(Indices_of_T_vector)]),[N_segments N_d_measures 1]);

D(:,:,1) = Dijkkosten2017;

M =  repmat(Maatregelkosten',[1 1 length(Indices_of_T_vector)]).*repmat(reshape((1+discount_factor).^[1-Indices_of_T_vector]',[1 1 length(Indices_of_T_vector)]),[1 N_m_measures 1]);
% M(m,g) costs of measure not related to dikes taken at time g

UM = zeros(N_segments, N_m_measures, length(Full_T_vector), length(Full_T_vector)); % UM(m,g,t,s) decrease of the dike shortage of dike segment s at time t if measure m is taken at time g

for g = 1:Indices_of_T_vector(end)
    for t = g:Indices_of_T_vector(end)
        
        UM(:,:,g,t) = permute(EffectenMeasures(:,t+1-g,:),[1 3 2]);
        
    end
end

UM = UM(:,:,Indices_of_T_vector,Indices_of_T_vector);

UD = zeros(N_segments,N_d_measures,length(Indices_of_T_vector),length(Indices_of_T_vector)); % UD(d,g,t) decrease of the dike shortage at time t if measure d is taken at time g

for g = 1:length(Indices_of_T_vector)
    for t = g:length(Indices_of_T_vector)
        
        UD(:,:,g,t) = repmat([[0.1:0.1:2] 2.5 3],[N_segments 1]);
        
    end
end

N = -reshape(Gaps,[N_segments 1 1 length(Indices_of_T_vector)]); % n(t,s) required additional amount of height for segment s at time t
lambda = 0;
M = 10^3;

tic

cvx_begin

    variable x(N_segments,N_d_measures,length(Indices_of_T_vector)) binary; % x(d,g,1,s) equal to 1 if measure d is taken at time g for segment s
    variable v(1,N_m_measures,length(Indices_of_T_vector)) binary; % v(m,g) equal to 1 if measure m is taken at time g
    variable obj
    variable w(N_segments,N_d_measures,length(Indices_of_T_vector)-1) nonnegative
    variable z(N_segments,1,length(Indices_of_T_vector)-1)
    
    minimize(obj)

    % Numbering of constraints the same as in Pustjens (2015)

    % Objective

    obj >= sum(sum(sum((x.*D)))) + sum(sum((v.*M))) + sum(sum(sum(w))); % Add summations
    
    toc

    % Constraint 1
    
    sum(sum(repmat(x,[1 1 1 length(Indices_of_T_vector)]).*UD,2),3) + sum(sum(repmat(v,[N_segments 1 1 length(Indices_of_T_vector)]).*UM,2),3) >= N;
    
    toc
    
    % Constraint 2
    
    sum(v,3) <= 1;
    
    toc
    
    % Constraint 3
    
    cumsum(sum(x(:,:,1:(length(Indices_of_T_vector)-1)).*repmat([[0.1:0.1:2] 2.5 3],[N_segments 1 (length(Indices_of_T_vector)-1)]),2),3) == z;
    
    toc
    
    % Constraint 4
    
    lambda*D(:,:,2:length(Indices_of_T_vector)).*repmat(z,[1 N_d_measures 1]) - M*(1-x(:,:,2:length(Indices_of_T_vector))) <= w ;
    
    toc
    
    % My extra constraint 1
    
    sum(x,2) <= 1;
    
    toc

cvx_end

