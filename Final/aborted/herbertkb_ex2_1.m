% herbertkb_ex2_1.m
% Keith Herbert
% Final Exam, Ex 2.1
% Kohonen Winner-Take-All Self Organizing Map

% CONSTANTS
INFILE      = 'Ex2_Data/Ex1_data.txt';
LEARN_0     = 0.1;
NEIGHBOR_0  = 1;
NEURON_CNT  = 2;


patterns = csvread(INFILE, 1,0);

x1 = patterns(:,1);
x2 = patterns(:,2);

x1_normalized = (x1 - min(x1)) / (max(x1) - min(x1));
x2_normalized = (x2 - min(x2)) / (max(x2) - min(x2));

patterns = [x1_normalized, x2_normalized];



neurons = unifrnd(0,1, NEURON_CNT)


n = 1
for i = 1:patterns

    X = patterns(i,:)
    disp(X)
    
% find the best matching unit
    norm( X - neurons(:), 2 ) 
    
    
    
    
    
    

end 






