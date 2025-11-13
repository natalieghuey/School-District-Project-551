%% School District Project

data=readtable('Bussing_table.csv');
proportions = [0.32 0.38 0.3; 0.37 0.28 0.35; 0.3 0.32 0.38; 0.28 0.4 0.32;...
    0.39 0.34 0.27; 0.34 0.28, 0.38];
Areatotals= [450 600 550 350 500 450];
Costs = data(:,5:7);
Costs = table2array(Costs);
prob=optimproblem('ObjectiveSense','minimize');
x=optimvar('x',6,3, 'LowerBound',0);
%% 
% To account for the fact we cannot bus students from Area 2 to School 1, Area 
% 4 to School 3, or Area 5 to School 2, we set these upper bounds to 0:

x(2,1).UpperBound = 0;
x(4,3).UpperBound = 0;
x(5,2).UpperBound = 0;
%% 
% We want to minimize cost so here is the objective function:

prob.Objective = sum(sum(Costs.*x));
%% 
% Constraints to move all students:

prob.Constraints.area1= -x(1,1)-x(1,2)-x(1,3) == -450;
prob.Constraints.area2= -x(2,2)-x(2,3) == -600;
prob.Constraints.area3 = -x(3,1)-x(3,2)-x(3,3) == -550;
prob.Constraints.area4 = -x(4,1)-x(4,2) == -350;
prob.Constraints.area5 = -x(5,1)-x(5,3) == -500;
prob.Constraints.area6 = -x(6,1)-x(6,2)-x(6,3) == -450;
%% 
% Constraint to not overfill schools:

prob.Constraints.school1 = x(1,1) + x(3,1) + x(4,1) + x(5,1) + x(6,1) <=900;
prob.Constraints.school2 = x(1,2) + x(2,2) + x(3,2) + x(4,2) + x(6,2) <=1100;
prob.Constraints.school3 = x(1,3) + x(2,3) + x(3,3) + x(5,3) + x(6,3) <=1000;
%% 
% Need to preserve proportions of each grade level at each school:
prob.Constraints.school1grade6lower = dot(proportions(:,1),x(:,1)) >= 0.3*sum(x(:,1));
prob.Constraints.school1grade6higher = dot(proportions(:,1),x(:,1)) <= 0.36*sum(x(:,1));
prob.Constraints.school1grade7lower = dot(proportions(:,2),x(:,1)) >= 0.3*sum(x(:,1));
prob.Constraints.school1grade7higher = dot(proportions(:,2),x(:,1)) <= 0.36*sum(x(:,1));
prob.Constraints.school1grade8lower = dot(proportions(:,3),x(:,1)) >= 0.3*sum(x(:,1));
prob.Constraints.school1grade8higher = dot(proportions(:,3),x(:,1)) <= 0.36*sum(x(:,1));
prob.Constraints.school2grade6lower = dot(proportions(:,1),x(:,2)) >= 0.3*sum(x(:,2));
prob.Constraints.school2grade6higher = dot(proportions(:,1),x(:,2)) <= 0.36*sum(x(:,2));
prob.Constraints.school2grade7lower = dot(proportions(:,2),x(:,2)) >= 0.3*sum(x(:,2));
prob.Constraints.school2grade7higher = dot(proportions(:,2),x(:,2)) <= 0.36*sum(x(:,2));
prob.Constraints.school2grade8lower = dot(proportions(:,3),x(:,2)) >= 0.3*sum(x(:,2));
prob.Constraints.school2grade8higher = dot(proportions(:,3),x(:,2)) <= 0.36*sum(x(:,2));
prob.Constraints.school3grade6lower = dot(proportions(:,1),x(:,3)) >= 0.3*sum(x(:,3));
prob.Constraints.school3grade6higher = dot(proportions(:,1),x(:,3)) <= 0.36*sum(x(:,3));
prob.Constraints.school3grade7lower = dot(proportions(:,2),x(:,3)) >= 0.3*sum(x(:,3));
prob.Constraints.school3grade7higher = dot(proportions(:,2),x(:,3)) <= 0.36*sum(x(:,3));
prob.Constraints.school3grade8lower = dot(proportions(:,3),x(:,3)) >= 0.3*sum(x(:,3));
prob.Constraints.school3grade8higher = dot(proportions(:,3),x(:,3)) <= 0.36*sum(x(:,3));
[sol,fval]= solve(prob)
sol.x