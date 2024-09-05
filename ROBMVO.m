function  x = ROBMVO(mu, Q, factRet)
    
    % Use this function to construct an example of a MVO portfolio.
    %
    % An example of an MVO implementation is given below. You can use this
    % version of MVO if you like, but feel free to modify this code as much
    % as you need to. You can also change the inputs and outputs to suit
    % your needs. 
    
    % You may use quadprog, Gurobi, or any other optimizer you are familiar
    % with. Just be sure to include comments in your code.

    % *************** WRITE YOUR CODE HERE ***************
    %----------------------------------------------------------------------
    
% Find the total number of assets
n = size(Q,1); 
N = 56;


% Optimal asset weights

theta = ((1/N)*diag(Q).*eye(n)).^0.5;
alpha = 0.9;
epsilon = sqrt(chi2inv(alpha,n));
lambda = 20;
%use fmincon
fun = @(x) lambda*transpose(x)*Q*x - (transpose(mu)*x-epsilon*norm(theta*x,2));
x0 = 1/n.*(ones(n,1));

A = [];
b = [];
Aeq = ones(1,n);
beq = 1;
lb = zeros(n,1);
ub = 0.3;
x = fmincon(fun,x0,A,b,Aeq,beq,lb, ub);

