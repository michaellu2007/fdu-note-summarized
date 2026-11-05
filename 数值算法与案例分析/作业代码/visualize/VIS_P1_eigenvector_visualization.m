% VIS_P1_eigenvector_visualization.m
% 补做可视化：2026-10-27 P1「上三角阵的全体特征向量，与 eig 比较」
% 原作业脚本只打印数值、不产生 figure；这里沿用作业代码的算法把结论画出来。
% 用法：MATLAB 里直接运行本脚本，PNG 会自动写到 ../figures/2026-10-27/。
% 生成环境：MATLAB R2025a，无头模式 -batch，print -dpng -r130。
set(0, 'DefaultFigureVisible', 'off');
warning('off', 'all');
OUT = [fullfile(fileparts(mfilename('fullpath')), '..', 'figures', '2026-10-27') filesep];
rng(2026);
fprintf('=== VIS P1 START ===\n');

%% ============ 2026-10-27 P1 : 回代法求上三角阵特征向量 ============
n = 50;
d = randperm(n);
A = diag(d) + triu(rand(n), 1);
[Ve, De] = eig(A);
de = diag(De);
res_my  = zeros(n, 1);
res_eig = zeros(n, 1);
angle_deg = zeros(n, 1);
for i = 1:n
    lam = A(i, i);
    v = triu_backsub_eigvec(A, i);
    res_my(i) = max(norm(A * v - lam * v) / norm(A, inf), realmin);
    [~, j] = min(abs(de - lam));
    ve = Ve(:, j);
    res_eig(i) = max(norm(A * ve - de(j) * ve) / norm(A, inf), realmin);
    angle_deg(i) = max(acos(min(1, abs(v' * ve))) * 180 / pi, realmin);
end

figure('Position', [100 100 720 460]);
subplot(2, 1, 1);
semilogy(1:n, res_my, 'b-o', 'MarkerSize', 3, 'LineWidth', 1); hold on;
semilogy(1:n, res_eig, 'r-^', 'MarkerSize', 3, 'LineWidth', 1);
grid on; legend('回代法 (作业代码)', 'MATLAB eig', 'Location', 'best');
xlabel('特征值编号 i'); ylabel('相对残差 \|Av-\lambda v\| / \|A\|');
title('P1 图 1a：逐个特征向量的残差（n = 50，对角元互异）');
subplot(2, 1, 2);
plot(1:n, angle_deg, 'k-s', 'MarkerSize', 3, 'LineWidth', 1);
grid on; xlabel('特征值编号 i'); ylabel('夹角 (度)');
title('P1 图 1b：回代法与 eig 得到特征向量的夹角（0 度 = 同一方向）');
print(gcf, '-dpng', '-r130', [OUT '20261027_P1_eigenvector_residual_fig1.png']);
close(gcf);
fprintf('OK 20261027_P1 fig1 | max residual = %.3e | max angle = %.3e deg\n', max(res_my), max(angle_deg));

% 特征值间隔缩小时，回代公式的分母 (A(k,k)-lambda) 会塌缩
ng = 12;   % 缩小规模，避免中间量在双精度里直接溢出成 Inf
gaps = logspace(0, -10, 21);
max_res = zeros(size(gaps));
max_growth = zeros(size(gaps));
for t = 1:numel(gaps)
    g = gaps(t);
    dd = 1 + (1:ng) * g;
    dd = dd(randperm(ng));
    Ag = diag(dd) + triu(rand(ng), 1);
    rr = 0; gg = 0;
    for i = 1:ng
        [v, vraw] = triu_backsub_eigvec(Ag, i);
        rr = max(rr, norm(Ag * v - Ag(i,i) * v) / norm(Ag, inf));
        gg = max(gg, min(norm(vraw), 1e150));
    end
    max_res(t) = max(rr, realmin);
    max_growth(t) = gg;
end
figure('Position', [100 100 720 460]);
yyaxis left;
loglog(gaps, max_res, 'b-o', 'LineWidth', 1.2); ylabel('最大相对残差');
yyaxis right;
loglog(gaps, max_growth, 'r-s', 'LineWidth', 1.2); ylabel('归一化前 \|v\| 的最大放大倍数');
set(gca, 'XDir', 'reverse'); grid on;
xlabel('相邻对角元间隔 \delta（从 1 缩到 10^{-10}，n = 12）');
title('P1 图 2：间隔越小，分母越小，回代中间向量被放大到 10^{100}（右轴封顶 10^{150}）');
print(gcf, '-dpng', '-r130', [OUT '20261027_P1_eigenvector_residual_fig2.png']);
close(gcf);
fprintf('OK 20261027_P1 fig2\n');

fprintf('=== VIS P1 END ===\n');

function [v, vraw] = triu_backsub_eigvec(A, i)
% 作业脚本的回代公式：v(k) = -(A(k,k+1:i)*v(k+1:i)) / (A(k,k)-lambda)
    n = size(A, 1);
    lambda = A(i, i);
    v = zeros(n, 1);
    v(i) = 1;
    for k = i-1:-1:1
        v(k) = -(A(k, k+1:i) * v(k+1:i)) / (A(k,k) - lambda);
    end
    vraw = v;
    v = v / norm(v);
end
