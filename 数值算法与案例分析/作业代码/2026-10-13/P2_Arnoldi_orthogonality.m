function [Q, H] = arnoldi_krylov(A, r, k, do_reorth)

    
    n = length(r);
    Q = zeros(n, k + 1); 
    H = zeros(k + 1, k); 

    norm_r = norm(r);
    if norm_r == 0
        error('初始向量 r 必须非零。');
    end
    Q(:, 1) = r / norm_r;

    for j = 1:k
        w = A * Q(:, j);
        for i = 1:j
            H(i, j) = Q(:, i)' * w; 
            w = w - H(i, j) * Q(:, i);
        end
        
        % 如果开启了重正交化，再减一遍影子（解决正交性损失）
        if do_reorth
            for i = 1:j
                corr = Q(:, i)' * w;
                H(i, j) = H(i, j) + corr;
                w = w - corr * Q(:, i);
            end
        end
        H(j+1, j) = norm(w);
        
        % 如果长度接近 0，说明 Krylov 子空间提前建满了
        if H(j+1, j) < 1e-12
            fprintf('在第 %d 步提前终止，空间已满。\n', j);
            Q = Q(:, 1:j);
            H = H(1:j+1, 1:j);
            return;
        end
        
        Q(:, j+1) = w / H(j+1, j);
    end
    Q = Q(:, 1:k);
    H = H(1:k+1, 1:k);
end

clear; clc; close all;


rng(42); 
n = 200; 
k = 100; 


A = (randn(n, n) + 1i * randn(n, n)) / sqrt(2 * n);
r = randn(n, 1) + 1i * randn(n, 1);

Q_no_fix = arnoldi_krylov(A, r, k, false);

Q_fixed = arnoldi_krylov(A, r, k, true);


loss_no_fix = zeros(k, 1);
loss_fixed = zeros(k, 1);

for j = 1:k
    I = eye(j);
    G_no_fix = Q_no_fix(:, 1:j)' * Q_no_fix(:, 1:j);
    loss_no_fix(j) = norm(G_no_fix - I, 'fro');
    
    G_fixed = Q_fixed(:, 1:j)' * Q_fixed(:, 1:j);
    loss_fixed(j) = norm(G_fixed - I, 'fro');
end

figure('Color', 'w');
semilogy(1:k, loss_no_fix, 'r-o', 'LineWidth', 1.5, 'MarkerSize', 4); hold on;
semilogy(1:k, loss_fixed, 'g-s', 'LineWidth', 1.5, 'MarkerSize', 4);

xlabel('Krylov 子空间维数 k', 'FontSize', 12);
ylabel('正交性损失 ||Q^H Q - I||_F', 'FontSize', 12);
title('Arnoldi 过程中的正交性损失', 'FontSize', 14);

legend('不修正 (误差飙升)', '重正交化修正 (误差极小)', ...
       'Location', 'northwest', 'FontSize', 11);
grid on;
set(gca, 'YScale', 'log'); % 确保 Y 轴是对数坐标