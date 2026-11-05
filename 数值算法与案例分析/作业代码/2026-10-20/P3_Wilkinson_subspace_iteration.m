clear; clc; close all;

n = 10;
N = 2*n + 1;
diag_vals = abs(n + 1 - (1:N));
W = diag(diag_vals) + diag(ones(N-1,1), 1) + diag(ones(N-1,1), -1);

exact_evals = sort(eig(W), 'descend');
top5_exact = exact_evals(1:5);

max_iter = 100;

m1 = 5;
rng(42); 
Q1 = orth(randn(N, m1)); 
err_hist_5 = zeros(max_iter, 5);
for k = 1:max_iter
    Z = W * Q1;                  
    [Q1, ~] = qr(Z, 0);          
    H = Q1' * W * Q1;            
    current_evals = sort(eig(H), 'descend');
    err_hist_5(k, :) = abs(current_evals - top5_exact)'; 
end

m2 = 6;
Q2 = orth(randn(N, m2)); 
err_hist_6 = zeros(max_iter, 5);
for k = 1:max_iter
    Z = W * Q2;
    [Q2, ~] = qr(Z, 0);
    H = Q2' * W * Q2;
    current_evals = sort(eig(H), 'descend');
    err_hist_6(k, :) = abs(current_evals(1:5) - top5_exact)'; 
end

figure('Color','w');
semilogy(1:max_iter, err_hist_5(:,5), '-o', 'LineWidth', 1.5, 'MarkerSize', 4);
hold on;
semilogy(1:max_iter, err_hist_6(:,5), '-s', 'LineWidth', 1.5, 'MarkerSize', 4);
grid on;
xlabel('Iteration Number');
ylabel('Absolute Error');
title('Convergence: 5 columns vs 6 columns');
legend('m=5', 'm=6', 'Location', 'northeast');