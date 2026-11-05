clear; clc; close all;
n = 50;

% 主对角线元素互不相同
d = randperm(n);          % 例如 [3 1 4 2]
B = rand(n); 
% 严格上三角部分随机整数
A = diag(d) + triu(B, 1);
V_my = zeros(n, n);
for i = 1:n
    lambda = A(i, i); % 第 i 个特征值就是对角线元素
    v = zeros(n, 1);
    v(i) = 1;         % 设当前特征值对应的分量初始值为 1
    
    % 核心逻辑：从第 i-1 行倒着循环到第 1 行（向上回代）
    for k = i-1:-1:1
        % 根据公式：v(k) = - (A(k, k+1:i) * v(k+1:i)) / (A(k,k) - lambda)
        v(k) = - (A(k, k+1:i) * v(k+1:i)) / (A(k,k) - lambda);
    end
    
    % 归一化（长度变为 1）
    V_my(:, i) = v / norm(v);
end
% 4. 调用 MATLAB 内置库函数 eig
[V_eig, D_eig] = eig(A);
% 6. 误差验证
disp('--- 验证结果 ---');
% (1) 验证特征值
err_eigenvalue = norm(sort(diag(A)) - sort(diag(D_eig)));
fprintf('特征值误差: %e\n', err_eigenvalue);

% (2) 验证特征向量 (注意：因为符号可能相反，我们验证 A*v - lambda*v = 0)
max_err = 0;
for i = 1:n
    lambda = A(i, i);
    v = V_my(:, i);
    % 计算残差 || A*v - lambda*v ||
    err = norm(A * v - lambda * v);
    if err > max_err
        max_err = err;
    end
end
fprintf('特征向量最大残差 (A*v - lambda*v): %e\n', max_err);

% (3) 验证与 eig 结果的夹角/方向
% 由于特征向量乘 -1 依然是特征向量，所以直接相减可能会有 2 的误差
% 我们比较绝对值
err_vs_eig = norm(abs(V_my) - abs(V_eig));
fprintf('与 eig 结果（绝对值）的差异: %e\n', err_vs_eig);