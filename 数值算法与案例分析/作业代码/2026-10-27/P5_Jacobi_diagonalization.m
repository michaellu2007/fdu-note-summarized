clear; clc; close all;
warning('off', 'MATLAB:rankDeficientMatrix');
%% 1. 性能测试与 D&C 对比
sizes = [10, 20, 30, 40, 60, 80, 120];
num_tests = length(sizes);
t_jacobi = zeros(num_tests, 1);
t_eig = zeros(num_tests, 1); 

fprintf('\n--- 1. 性能与速度对比测试 ---\n');
for i = 1:num_tests
    n = sizes(i);
    rng(42);
    M = randn(n, n);
    A0 = (M + M') / 2; 
    
    % 测 Jacobi
    tic_jac = 0;
    for k = 1:3
        tic;
        jacobi_variants(A0, 'max', n^3);
        tic_jac = tic_jac + toc;
    end
    t_jacobi(i) = tic_jac / 3;
    
    % 测 MATLAB 内置 eig (D&C)
    t_eig(i) = timeit(@() eig(A0));
end

% 图 1：纯 Jacobi 性能
figure('Name', 'Fig 1: Jacobi Performance');
plot(sizes, t_jacobi, '-ro', 'LineWidth', 2, 'MarkerSize', 8);
xlabel('Matrix Size (n)'); ylabel('Time (seconds)');
title('Jacobi Performance'); grid on;

% 图 2：Jacobi vs D&C
figure('Name', 'Fig 2: Jacobi vs D&C');
loglog(sizes, t_jacobi, '-ro', 'LineWidth', 2, 'MarkerSize', 8); hold on;
loglog(sizes, t_eig, '-b^', 'LineWidth', 2, 'MarkerSize', 8);
xlabel('Matrix Size n (log scale)'); ylabel('Execution Time (seconds, log scale)');
title('Performance Comparison: Jacobi vs D&C (MATLAB eig)');
legend('Jacobi (Max Pivot)', 'D&C (MATLAB eig)', 'Location', 'northwest'); grid on;


%% 2. 收敛历史与 Componentwise 观察
fprintf('\n--- 2. 生成收敛与 Componentwise 对比图 ---\n');
n = 20;
rng(1);
M = randn(n, n);
A0 = (M + M') / 2; 

% 跑三种策略 (Max, 固定循环 Cyclic, 错误动态最小)
[~, hist_norm_max, hist_max_max] = jacobi_variants(A0, 'max', 500);
[~, hist_norm_cyc, hist_max_cyc] = jacobi_variants(A0, 'cyclic', 50); 
[~, hist_norm_min, hist_max_min] = jacobi_variants(A0, 'wrong_min', 500);

% 图 3：总体收敛历史 (Frobenius 范数)
figure('Name', 'Fig 3: Convergence History');
semilogy(1:length(hist_norm_max), hist_norm_max, '-r', 'LineWidth', 2); hold on;
semilogy(1:length(hist_norm_cyc), hist_norm_cyc, '-k', 'LineWidth', 2);
semilogy(1:length(hist_norm_min), hist_norm_min, '-b', 'LineWidth', 2);
xlabel('Iteration (or Sweep for Cyclic)');
ylabel('Off-diagonal Frobenius Norm (log scale)');
title('Convergence History (Overall)');
legend('Max Pivot (Correct)', 'Cyclic (Fixed Rotation Order)', 'Wrong Min (Dynamic)', 'Location', 'best');
grid on;

% 图 4：Componentwise 观察
figure('Name', 'Fig 4: Componentwise Observation');
semilogy(1:length(hist_max_max), hist_max_max, '-r', 'LineWidth', 2); hold on;
semilogy(1:length(hist_max_cyc), hist_max_cyc, '-k', 'LineWidth', 2);
semilogy(1:length(hist_max_min), hist_max_min, '-b', 'LineWidth', 2);
xlabel('Iteration (or Sweep for Cyclic)');
ylabel('Max Off-diagonal Element |A_{ij}| (log scale)');
title('Componentwise Observation');
legend('Max Pivot', 'Cyclic', 'Wrong Min', 'Location', 'best');
grid on;

fprintf('运行完毕！请查看生成的 4 张图。\n');


% =========================================================================
% 局部函数定义
% =========================================================================
function [A, hist_norm, hist_max_elem, iters] = jacobi_variants(A, strategy, max_iter)
    n = size(A, 1);
    hist_norm = zeros(max_iter, 1);
    hist_max_elem = zeros(max_iter, 1);
    iters = 0;
    
    [I, J] = find(triu(ones(n), 1));
    pairs = [I, J];
    
    for iter = 1:max_iter
        off_diag = triu(A, 1);
        
        if max(abs(off_diag(:))) < 1e-14
            hist_norm = hist_norm(1:iters);
            hist_max_elem = hist_max_elem(1:iters);
            return;
        end
        
        if strcmp(strategy, 'max')
            [~, idx] = max(abs(off_diag(:)));
            [p, q] = ind2sub([n, n], idx);
            A = execute_rotation(A, p, q);
            iters = iters + 1;
            hist_norm(iters) = norm(triu(A, 1), 'fro');
            hist_max_elem(iters) = max(abs(triu(A, 1)), [], 'all');
            
        elseif strcmp(strategy, 'wrong_min')
            temp = abs(off_diag);
            temp(temp < 1e-14) = Inf; 
            [~, idx] = min(temp(:));
            [p, q] = ind2sub([n, n], idx);
            A = execute_rotation(A, p, q);
            iters = iters + 1;
            hist_norm(iters) = norm(triu(A, 1), 'fro');
            hist_max_elem(iters) = max(abs(triu(A, 1)), [], 'all');
            
        elseif strcmp(strategy, 'cyclic')
            % 标准的 Rotation 循环排序：按坐标 (1,2)->(1,3)... 依次执行
            for k = 1:size(pairs, 1)
                p = pairs(k, 1); q = pairs(k, 2);
                if abs(A(p, q)) > 1e-14
                    A = execute_rotation(A, p, q);
                end
            end
            iters = iters + 1;
            hist_norm(iters) = norm(triu(A, 1), 'fro');
            hist_max_elem(iters) = max(abs(triu(A, 1)), [], 'all');
        end
    end
end

function A = execute_rotation(A, p, q)
    if A(p, p) == A(q, q)
        theta = pi / 4;
    else
        theta = 0.5 * atan2(2 * A(p, q), A(p, p) - A(q, q));
    end
    c = cos(theta); s = sin(theta);
    
    a_p = A(:, p); a_q = A(:, q);
    A(:, p) = c * a_p - s * a_q;
    A(:, q) = s * a_p + c * a_q;
    
    a_p = A(p, :); a_q = A(q, :);
    A(p, :) = c * a_p - s * a_q;
    A(q, :) = s * a_p + c * a_q;
    
    A(p, q) = 0; A(q, p) = 0;
end