% =========================================================================
% Problem 4: Forward error of computed eigenvalues for a defective matrix
% =========================================================================
clc; clear; close all;

% 固定随机种子，保证每次运行结果一致，方便写作业报告
rng(12345); 
J = [2 1 0 0 0;
     0 2 1 0 0;
     0 0 2 0 0;
     0 0 0 5 1;
     0 0 0 0 5];

n = size(J, 1);
X = randn(n, n);
while rank(X) < n
    X = randn(n, n);
end
% 注意：在 MATLAB 中 X * J / X 比 X * J * inv(X) 计算更快且数值更稳定
A = X * J / X; 

% 获取真实的理论特征值（就是 J 的对角线元素）
true_eigs = diag(J);

%% 第二部分：计算特征值并分析前向误差
% 计算机计算出的特征值
computed_eigs = eig(A);

% 因为算出来的特征值可能带有虚部且顺序打乱，我们需要排序后计算误差
% 取实部进行排序（因为真实特征值都是实数）
[~, idx] = sort(real(computed_eigs));
computed_eigs_sorted = computed_eigs(idx);
true_eigs_sorted = sort(true_eigs);

% 计算绝对前向误差
forward_errors = abs(computed_eigs_sorted - true_eigs_sorted);

%% 打印结果
fprintf('=== 实验组：带有非平凡 Jordan 块的矩阵 A ===\n');
fprintf('矩阵 X 的条件数 cond(X) = %.4e\n', cond(X));
fprintf('真实特征值\t 计算出的特征值\t\t 前向误差\n');
for i = 1:n
    fprintf('%5.2f \t\t %5.2f %+.2fi \t\t %.4e\n', ...
        true_eigs_sorted(i), real(computed_eigs_sorted(i)), imag(computed_eigs_sorted(i)), forward_errors(i));
end


%% 第三部分：进阶对照实验（强烈建议加到作业里！）
% 为了证明"误差爆炸"是因为 Jordan 块，我们把 J 变成纯对角阵（去掉上三角的 1）
fprintf('\n=== 对照组：将 J 变为纯对角阵（消除 Jordan 块） ===\n');
J_diag = diag(diag(J)); % 只保留对角线元素
A_diag = X * J_diag / X; % 使用同一个 X

computed_eigs_diag = eig(A_diag);
[~, idx_diag] = sort(real(computed_eigs_diag));
computed_eigs_diag_sorted = computed_eigs_diag(idx_diag);
forward_errors_diag = abs(computed_eigs_diag_sorted - true_eigs_sorted);

fprintf('真实特征值\t 计算出的特征值\t\t 前向误差\n');
for i = 1:n
    fprintf('%5.2f \t\t %5.2f %+.2fi \t\t %.4e\n', ...
        true_eigs_sorted(i), real(computed_eigs_diag_sorted(i)), imag(computed_eigs_diag_sorted(i)), forward_errors_diag(i));
end