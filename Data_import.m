% Data import and setup 

Full_T_vector = [2017:2197]';
%Indices_of_T_vector = [[1:5:Horizon+1]]';
Indices_of_T_vector = [[1:5:81] [91:10:181]]';
T_vector = Full_T_vector(Indices_of_T_vector);

N_segments = 150;
N_d_measures = 22;

Gaps = xlsread('Gaps.xlsx','Sheet1','e2:gf151');
Gaps = Gaps(:,Indices_of_T_vector);

N_m_measures = 14;
EffectenMeasures = zeros(150,184,14);

for iterate_measure = 1:14
    
    EffectenMeasures(:,:,iterate_measure) =  xlsread('EffectenMeasures2.xlsx',2*iterate_measure+1,'e2:gf151');
    
end

% EffectenMeasures = EffectenMeasures(:,Indices_of_T_vector,:);

Dijkkosten = zeros(N_segments,N_d_measures);
Dijkkosten = xlsread('Dijkkosten(beter).xlsx','finalwithoutpipecosts','e3:z152');
Dijkkosten2017 = xlsread('Dijkkosten(beter).xlsx','FinalCosts','f3:aa152');

Maatregelkosten = xlsread('Maatregelkosten.xlsx','Aangepast_kosten_maatregelen','b2:b15');

Maatregelkosten2017 = [1098.53
                       1154.89
                       1918.41
                       1918.41
                       402.18
                       3523.07
                       572.64
                       487.98
                       281.17
                       149.82
                       43.55
                       2324.72
                       1620.97
                       1453.67];
                   
                   
                   
% Regression of the water levels

start_level = zeros(size(Gaps,1),1);
beta_vector = zeros(size(Gaps,1),1);

for iterate_segment = 1:size(Gaps,1)
    
    regressed = [ones(Horizon/5+1,1) 5*[0:(Horizon/5)]']\(-Gaps(iterate_segment,:)');
    start_level(iterate_segment) = regressed(1);
    beta_vector(iterate_segment) = regressed(2);
    
end
