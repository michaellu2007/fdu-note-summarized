clear; clc; close all;
n = 1000; 
M = randn(n) + 1i * randn(n);
A = M * M' + n * eye(n); 
A = (A + A') / 2;

% A = V * D * V'，sqrt(A) = V * sqrt(D) * V'
[V, D] = eig(A);
true_sqrtA = V * sqrt(D) * V';
X = eye(n);           
max_iter = 40;         
tol = 1e-16;           % 收敛容差
errors = zeros(max_iter, 1); % 用于记录每次迭代的误差

fprintf('开始牛顿迭代...\n');
fprintf('迭代次数\t相对误差 ||X_k - A^{1/2}||_F / ||A^{1/2}||_F\n');


for k = 1:max_iter
    
    errors(k) = norm(X - true_sqrtA, 'fro') / norm(true_sqrtA, 'fro');
    
    fprintf('%3d\t\t%e\n', k-1, errors(k));
    
   
    if errors(k) < tol
        fprintf('在第 %d 次迭代后收敛。\n', k-1);
        errors = errors(1:k); 
        break;
    end
    
    X = (X + X \ A) / 2; 
end


figure;
semilogy(0:length(errors)-1, errors, '-o', 'LineWidth', 2, 'MarkerSize', 8);
xlabel('Iteration (k)', 'Interpreter', 'latex', 'FontSize', 12);
ylabel('Relative Error \( \frac{||X_k - A^{1/2}||_F}{||A^{1/2}||_F} \)', 'Interpreter', 'latex', 'FontSize', 12);
title('Convergence of Newton Iteration for Matrix Square Root', 'FontSize', 14);
grid on;