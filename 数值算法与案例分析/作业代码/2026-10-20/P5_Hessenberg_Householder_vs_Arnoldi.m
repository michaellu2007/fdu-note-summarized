% =========================================================================
% Hessenberg Reduction: Householder vs. Arnoldi (MGS)
% 对比测试：随机矩阵 (randn) vs. 极度非正规矩阵 (上三角全1)
% =========================================================================
clear; clc; close all;

%% ================= 第一部分：热力图对比 (n = 50) =================
n = 50;
rng(2024); 

% 生成两种矩阵
A_rand = randn(n, n);
A_triu = triu(ones(n), 1);

% 计算两种矩阵在两种算法下的结果
[Qh_rand, ~] = hessenberg_householder(A_rand);
[Qa_rand, ~] = hessenberg_arnoldi_mgs(A_rand, 1);
[Qh_triu, ~] = hessenberg_householder(A_triu);
[Qa_triu, ~] = hessenberg_arnoldi_mgs(A_triu, 2);

% 计算误差矩阵
Err_h_r = abs(Qh_rand' * Qh_rand - eye(n));
Err_a_r = abs(Qa_rand' * Qa_rand - eye(n));
Err_h_t = abs(Qh_triu' * Qh_triu - eye(n));
Err_a_t = abs(Qa_triu' * Qa_triu - eye(n));

% 画图
figure('Name', '正交性误差矩阵对比', 'Position', [100, 100, 1000, 800]);
color_range = [-18, 0]; % 统一颜色标尺，拉大范围以容纳上三角矩阵的巨大误差

% --- 第一行：随机矩阵 ---
subplot(2, 2, 1);
imagesc(log10(Err_h_r + eps)); colorbar; caxis(color_range);
title(['randn - Householder: ||Q^T Q - I||_F = ', num2str(norm(Qh_rand'*Qh_rand-eye(n),'fro'), '%.2e')]);
ylabel('Randn 矩阵');

subplot(2, 2, 2);
imagesc(log10(Err_a_r + eps)); colorbar; caxis(color_range);
title(['randn - Arnoldi: ||Q^T Q - I||_F = ', num2str(norm(Qa_rand'*Qa_rand-eye(n),'fro'), '%.2e')]);

% --- 第二行：上三角全 1 矩阵 ---
subplot(2, 2, 3);
imagesc(log10(Err_h_t + eps)); colorbar; caxis(color_range);
title(['triu - Householder: ||Q^T Q - I||_F = ', num2str(norm(Qh_triu'*Qh_triu-eye(n),'fro'), '%.2e')]);
ylabel('上三角全1矩阵');

subplot(2, 2, 4);
imagesc(log10(Err_a_t + eps)); colorbar; caxis(color_range);
title(['triu - Arnoldi: ||Q^T Q - I||_F = ', num2str(norm(Qa_triu'*Qa_triu-eye(n),'fro'), '%.2e')]);

colormap(parula); 

%% ================= 第二部分：误差随维度 n 增长趋势 =================
ns = 10:10:100;
errs_h_rand = zeros(length(ns), 1);
errs_a_rand = zeros(length(ns), 1);
errs_h_triu = zeros(length(ns), 1);
errs_a_triu = zeros(length(ns), 1);

for i = 1:length(ns)
    n = ns(i);
    A1 = randn(n, n);
    A2 = triu(ones(n), 1);
    
    [Qh1, ~] = hessenberg_householder(A1);
    [Qa1, ~] = hessenberg_arnoldi_mgs(A1, i);
    [Qh2, ~] = hessenberg_householder(A2);
    [Qa2, ~] = hessenberg_arnoldi_mgs(A2, i);
    
    errs_h_rand(i) = norm(Qh1' * Qh1 - eye(n), 'fro');
    errs_a_rand(i) = norm(Qa1' * Qa1 - eye(n), 'fro');
    errs_h_triu(i) = norm(Qh2' * Qh2 - eye(n), 'fro');
    errs_a_triu(i) = norm(Qa2' * Qa2 - eye(n), 'fro');
end

figure('Name', '误差随维度变化', 'Position', [200, 200, 800, 500]);
semilogy(ns, errs_h_rand, '-o', 'LineWidth', 2, 'MarkerSize', 6); hold on;
semilogy(ns, errs_a_rand, '-s', 'LineWidth', 2, 'MarkerSize', 6);
semilogy(ns, errs_h_triu, '--o', 'LineWidth', 2, 'MarkerSize', 6);
semilogy(ns, errs_a_triu, '--s', 'LineWidth', 2, 'MarkerSize', 6);

grid on;
xlabel('矩阵维度 n', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('||Q^T Q - I||_F (对数坐标)', 'FontSize', 12, 'FontWeight', 'bold');
title('Loss of Orthogonality Comparison', 'FontSize', 14);
legend('randn: Householder', 'randn: Arnoldi', 'triu: Householder', 'triu: Arnoldi', 'Location', 'northwest', 'FontSize', 11);
set(gca, 'FontSize', 11);

%% ================= 函数定义区 =================
function [Q, H] = hessenberg_householder(A)
    n = size(A, 1);
    H = A;
    Q = eye(n);
    for k = 1:(n-2)
        x = H(k+1:n, k);
        nx = norm(x);
        
        if nx == 0
            continue; 
        end
        
        e1 = zeros(length(x), 1); e1(1) = 1;
        s = 1; if x(1) ~= 0, s = sign(x(1)); end
        v = x + s * nx * e1;
        v = v / norm(v);
        
        H(k+1:n, k:n) = H(k+1:n, k:n) - 2 * v * (v' * H(k+1:n, k:n));
        H(1:n, k+1:n) = H(1:n, k+1:n) - 2 * (H(1:n, k+1:n) * v) * v';
        Q(:, k+1:n) = Q(:, k+1:n) - 2 * (Q(:, k+1:n) * v) * v';
    end
end

function [Q, H] = hessenberg_arnoldi_mgs(A, seed)
    n = size(A, 1);
    Q = zeros(n, n);
    H = zeros(n, n);
    
    rng(seed); 
    q = randn(n, 1);
    Q(:, 1) = q / norm(q);
    
    for j = 1:n
        w = A * Q(:, j);
        
        for i = 1:j
            H(i, j) = Q(:, i)' * w;
            w = w - H(i, j) * Q(:, i);
        end
        
        if j < n
            H(j+1, j) = norm(w);
            
            if H(j+1, j) > 1e-12
                Q(:, j+1) = w / H(j+1, j);
            else
                % 遇到 breakdown 时，随机生成并严格双重正交化
                v_rand = randn(n, 1);
                for p = 1:j
                    v_rand = v_rand - (Q(:, p)' * v_rand) * Q(:, p);
                end
                for p = 1:j
                    v_rand = v_rand - (Q(:, p)' * v_rand) * Q(:, p);
                end
                Q(:, j+1) = v_rand / norm(v_rand);
            end
        end
    end
end