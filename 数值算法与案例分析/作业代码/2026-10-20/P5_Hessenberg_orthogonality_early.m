% 清理环境
clear; clc; close all;

%% ================= 第一部分：热力图对比 (n = 100) =================
n = 100;
A = randn(n, n);

% 运行两种算法
[Q_h, ~] = hessenberg_householder(A);
[Q_a, ~] = hessenberg_arnoldi_mgs(A);

% 计算正交性误差矩阵 (理想情况下应该是全 0 矩阵)
Err_h = abs(Q_h' * Q_h - eye(n));
Err_a = abs(Q_a' * Q_a - eye(n));

% 画图
figure('Name', '正交性误差矩阵对比', 'Position', [100, 100, 900, 400]);

subplot(1, 2, 1);
imagesc(Err_h);
colorbar; caxis([0, 1e-12]); % 统一颜色标尺，方便对比
title(['Householder: ||Q^T Q - I||_F = ', num2str(norm(Q_h'*Q_h - eye(n), 'fro'), '%.2e')]);
xlabel('列'); ylabel('行');
colormap(flipud(gray)); % 越黑误差越小，越白误差越大

subplot(1, 2, 2);
imagesc(Err_a);
colorbar; caxis([0, 1e-12]); 
title(['Arnoldi (MGS): ||Q^T Q - I||_F = ', num2str(norm(Q_a'*Q_a - eye(n), 'fro'), '%.2e')]);
xlabel('列'); ylabel('行');

%% ================= 第二部分：误差随维度 n 增长趋势 =================
ns = 10:10:200;
errs_h = zeros(length(ns), 1);
errs_a = zeros(length(ns), 1);

for i = 1:length(ns)
    n = ns(i);
    A = randn(n, n);
    
    [Q_h, ~] = hessenberg_householder(A);
    [Q_a, ~] = hessenberg_arnoldi_mgs(A);
    
    errs_h(i) = norm(Q_h' * Q_h - eye(n), 'fro');
    errs_a(i) = norm(Q_a' * Q_a - eye(n), 'fro');
end

figure('Name', '正交性误差随矩阵维度变化', 'Position', [200, 200, 700, 500]);
semilogy(ns, errs_h, '-o', 'LineWidth', 2, 'MarkerSize', 6); hold on;
semilogy(ns, errs_a, '-s', 'LineWidth', 2, 'MarkerSize', 6);
grid on;
xlabel('矩阵维度 n', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('正交性误差 ||Q^T Q - I||_F (对数坐标)', 'FontSize', 12, 'FontWeight', 'bold');
title('Loss of Orthogonality: Householder vs Arnoldi', 'FontSize', 14);
legend('Householder', 'Arnoldi (MGS)', 'Location', 'northwest', 'FontSize', 12);
set(gca, 'FontSize', 11);

%% ================= 函数定义区 =================
function [Q, H] = hessenberg_householder(A)
    n = size(A, 1);
    H = A;
    Q = eye(n);
    for k = 1:(n-2)
        x = H(k+1:n, k);
        e1 = zeros(length(x), 1); e1(1) = 1;
        s = 1; if x(1) ~= 0, s = sign(x(1)); end
        v = x + s * norm(x) * e1;
        v = v / norm(v);
        H(k+1:n, k:n) = H(k+1:n, k:n) - 2 * v * (v' * H(k+1:n, k:n));
        H(1:n, k+1:n) = H(1:n, k+1:n) - 2 * (H(1:n, k+1:n) * v) * v';
        Q(:, k+1:n) = Q(:, k+1:n) - 2 * (Q(:, k+1:n) * v) * v';
    end
end

function [Q, H] = hessenberg_arnoldi_mgs(A)
    n = size(A, 1);
    Q = zeros(n, n);
    H = zeros(n, n);
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
                v_rand = randn(n, 1);
                for p = 1:j
                    v_rand = v_rand - (Q(:, p)' * v_rand) * Q(:, p);
                end
                Q(:, j+1) = v_rand / norm(v_rand);
            end
        end
    end
end