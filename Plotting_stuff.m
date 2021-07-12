
% Plotting a selected dike segment water level evolution and dike height

dike_segment = 60;

plot(2016+Indices_of_T_vector,reshape(N(dike_segment,:,:,:),[length(Indices_of_T_vector) 1]))
hold on;
scatter(2016+Indices_of_T_vector,reshape(sum(sum(repmat(x(dike_segment,:,:),[1 1 1 length(Indices_of_T_vector)]).*UD(dike_segment,:,:,:),2),3) + sum(sum(repmat(v,[1 1 1 length(Indices_of_T_vector)]).*UM(125,:,:,:),2),3),[length(Indices_of_T_vector) 1]));
hold off;

