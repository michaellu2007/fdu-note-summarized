
clear; clc; close all;

rng(42); 
n = 1000; 
A = rand(n, n);

v = rand(n, 1);

num_iterations = 100;
eigenvalue_history = zeros(num_iterations, 1);
for k = 1:num_iterations
    w = A * v;
    v_new = w / norm(w);
    lambda_est = v_new' * A * v_new; 
    eigenvalue_history(k) = lambda_est;
    v = v_new;
end

true_eigenvalues = eig(A);
rho_A = max(abs(true_eigenvalues));
figure('Color', 'w'); 

plot(1:num_iterations, eigenvalue_history, 'b-', 'LineWidth', 2); hold on;

yline(rho_A, 'r--', 'LineWidth', 2);
xlabel('迭代次数 (k)', 'FontSize', 12);
ylabel('特征值估计值 (\lambda)', 'FontSize', 12);
title('幂法 (Power Iteration) 的收敛历史', 'FontSize', 14);
legend('幂法估计值', ['真实谱半径 \rho(A) = ', num2str(rho_A, '%.4f')], ...
       'Location', 'southeast', 'FontSize', 11);
grid on;
fprintf('真实的谱半径 rho(A): %.6f\n', rho_A);
fprintf('幂法迭代 100 次后的估计值: %.6f\n', eigenvalue_history(end));
fprintf('绝对误差: %.2e\n', abs(eigenvalue_history(end) - rho_A));