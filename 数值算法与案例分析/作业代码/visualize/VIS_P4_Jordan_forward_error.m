% VIS_P4_Jordan_forward_error.m
% 补做可视化：2026-11-03 P4「非平凡 Jordan 块的特征值前向误差」
% 原作业脚本只打印数值、不产生 figure；这里沿用作业代码的算法把结论画出来。
% 用法：MATLAB 里直接运行本脚本，PNG 会自动写到 ../figures/2026-11-03/。
% 生成环境：MATLAB R2025a，无头模式 -batch，print -dpng -r130。
set(0, 'DefaultFigureVisible', 'off');
warning('off', 'all');
OUT = [fullfile(fileparts(mfilename('fullpath')), '..', 'figures', '2026-11-03') filesep];
rng(2026);
fprintf('=== VIS P4 START ===\n');

%% ============ 2026-11-03 P4 : Jordan 块特征值的前向误差 ============
% 图 1：m 重 Jordan 块在左下角加扰动 delta，特征值精确分裂为 delta^(1/m)
deltas = 10 .^ (-14:0.5:-2);
ms = [1 2 3 4 6];
err = zeros(numel(ms), numel(deltas));
for a = 1:numel(ms)
    m = ms(a);
    for b = 1:numel(deltas)
        if m == 1
            J = 2 + deltas(b);          % 1 阶块：扰动直接加在对角元上
        else
            J = 2 * eye(m) + diag(ones(m-1, 1), 1);
            J(m, 1) = deltas(b);       % 只在左下角加扰动
        end
        ev = eig(J);
        err(a, b) = max(max(abs(ev - 2)), realmin);
    end
end
figure('Position', [100 100 720 460]);
cols = lines(numel(ms));
for a = 1:numel(ms)
    loglog(deltas, err(a, :), '-o', 'Color', cols(a,:), 'MarkerSize', 3, 'LineWidth', 1.2); hold on;
end
loglog(deltas, deltas, 'k--', 'LineWidth', 1);
grid on; xlabel('扰动 \delta'); ylabel('特征值前向误差 |\lambda-2|');
legend('m=1 (斜率 1)', 'm=2 (斜率 1/2)', 'm=3 (斜率 1/3)', 'm=4 (斜率 1/4)', 'm=6 (斜率 1/6)', '参考斜率 1', 'Location', 'best');
title('P4 图 1：m 重 Jordan 块的误差 ~ \delta^{1/m}（双 log）');
print(gcf, '-dpng', '-r130', [OUT '20261103_P4_Jordan_forward_error_fig1.png']);
close(gcf);
fprintf('OK 20261103_P4 fig1 | delta=%.0e, m=4 err=%.3e\n', deltas(1), err(4,1));

% 图 2：对照实验 —— 非平凡 Jordan 块 vs 真对角阵
J1 = [2 1 0 0 0; 0 2 1 0 0; 0 0 2 0 0; 0 0 0 5 1; 0 0 0 0 5];
J2 = diag([2 2 2 5 5]);
exact = [2; 2; 2; 5; 5];
X = randn(5);
e_jordan = jordan_forward_error(X, J1, exact);
e_diag   = jordan_forward_error(X, J2, exact);
figure('Position', [100 100 720 420]);
semilogy(1:5, e_jordan, 'ro-', 'LineWidth', 1.4, 'MarkerSize', 8, 'MarkerFaceColor', 'r'); hold on;
semilogy(1:5, e_diag, 'bs-', 'LineWidth', 1.4, 'MarkerSize', 8, 'MarkerFaceColor', 'b');
grid on;
set(gca, 'XTick', 1:5, 'XTickLabel', {'\lambda=2 (1)','\lambda=2 (2)','\lambda=2 (3)','\lambda=5 (1)','\lambda=5 (2)'});
xlabel('特征值（按真实值排序）');
ylabel('前向误差 |\lambda_{计算} - \lambda_{真实}|');
legend('A = XJX^{-1}，J 含非平凡 Jordan 块', 'A = XJX^{-1}，J 为真对角阵 (可对角化)', 'Location', 'best');
title('P4 图 2：同样经过 XJX^{-1}，有 Jordan 块时误差大 9 个数量级');
ylim([1e-17 1e-3]);
print(gcf, '-dpng', '-r130', [OUT '20261103_P4_Jordan_forward_error_fig2.png']);
close(gcf);
fprintf('OK 20261103_P4 fig2 | jordan max=%.3e, diag max=%.3e\n', max(e_jordan), max(e_diag));

% 图 3：相似变换矩阵 X 越病态，舍入被放大得越厉害
conds = 10 .^ (0:2:10);
e_cond = zeros(size(conds));
for t = 1:numel(conds)
    Xt = gallery('randsvd', 5, conds(t));
    ec = jordan_forward_error(Xt, J1, exact);
    e_cond(t) = max(ec);
end
figure('Position', [100 100 720 420]);
loglog(conds, e_cond, 'm-o', 'LineWidth', 1.3, 'MarkerSize', 5); hold on;
grid on; xlabel('cond(X)'); ylabel('最大特征值前向误差');
title('P4 图 3：构造 A = XJX^{-1} 时，X 越病态误差越大');
print(gcf, '-dpng', '-r130', [OUT '20261103_P4_Jordan_forward_error_fig3.png']);
close(gcf);
fprintf('OK 20261103_P4 fig3\n');

fprintf('=== EXTRA VIS END ===\n');

fprintf('=== VIS P4 END ===\n');

function e = jordan_forward_error(X, J, exact)
    A = X * J / X;
    ev = eig(A);
    e = zeros(numel(exact), 1);
    used = false(numel(ev), 1);
    for i = 1:numel(exact)
        [~, j] = min(abs(ev - exact(i)) + 1e8 * used);
        used(j) = true;
        e(i) = abs(ev(j) - exact(i));
    end
    e = max(e, realmin);
end
