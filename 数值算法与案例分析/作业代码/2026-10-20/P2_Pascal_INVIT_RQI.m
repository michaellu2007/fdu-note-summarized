% 清除工作区与命令行
clear; clc; close all;
warning('off', 'MATLAB:nearlySingularMatrix');

% 1. 构建 10x10 帕斯卡矩阵
n = 10;
P10 = pascal(n);

% 迭代参数设置
max_iter = 15;
tol = 1e-14;

%% 2. 逆迭代法 (INVIT) 
% 寻找最小特征值，平移量 sigma = 0
v_invit = rand(n, 1);
v_invit = v_invit / norm(v_invit);
res_invit = zeros(max_iter, 1);
lambda_invit_history = zeros(max_iter, 1);

for k = 1:max_iter
    % 求解 (A - 0*I)w = v，即 Aw = v
    w = P10 \ v_invit; 
    
    % 归一化
    v_invit = w / norm(w);
    
    % 计算瑞利商作为特征值的估计
    lambda_k = v_invit' * P10 * v_invit;
    lambda_invit_history(k) = lambda_k;
    
    % 【关键修改】计算残差范数：||A*v - lambda*v||
    % 完全不依赖精确特征值
    res_invit(k) = norm(P10 * v_invit - lambda_k * v_invit);
    
    % 检查收敛性
    if res_invit(k) < tol && k > 1
        res_invit(k+1:end) = res_invit(k);
        lambda_invit_history(k+1:end) = lambda_k;
        break;
    end
end

%% 3. 瑞利商迭代法 (RQI)
v_rqi = rand(n, 1);
v_rqi = v_rqi / norm(v_rqi);
res_rqi = zeros(max_iter, 1);
lambda_rqi_history = zeros(max_iter, 1);

mu = 0; % 初始平移量为0，用于锁定最小特征值

for k = 1:max_iter
    % 求解 (A - mu*I)w = v
    w = (P10 - mu * eye(n)) \ v_rqi;
    
    % 归一化
    v_rqi = w / norm(w);
    
    % 更新瑞利商
    mu = v_rqi' * P10 * v_rqi;
    lambda_rqi_history(k) = mu;
    
    % 计算残差范数
    res_rqi(k) = norm(P10 * v_rqi - mu * v_rqi);
    
    % 检查收敛性
    if res_rqi(k) < tol && k > 1
        res_rqi(k+1:end) = res_rqi(k);
        lambda_rqi_history(k+1:end) = mu;
        break;
    end
end

%% 4. 可视化收敛历史
figure('Color', 'w');
semilogy(1:max_iter, res_invit, '-o', 'LineWidth', 1.5, 'MarkerSize', 6);
hold on;
semilogy(1:max_iter, res_rqi, '-s', 'LineWidth', 1.5, 'MarkerSize', 6);
grid on;

% 图例与标签设置
xlabel('迭代次数 (Iteration)', 'FontSize', 12);
ylabel('残差范数 ||A v - \lambda v||_2', 'FontSize', 12);
title('INVIT 与 RQI 收敛历史 (基于残差)', 'FontSize', 14);
legend('逆迭代法 (INVIT)', '瑞利商迭代法 (RQI)', 'FontSize', 12, 'Location', 'northeast');

% 打印最终计算结果（完全由算法自己算出）
fprintf('INVIT 算出的最小特征值: %.15e\n', lambda_invit_history(end));
fprintf('RQI 算出的最小特征值:   %.15e\n', lambda_rqi_history(end));

warning('on', 'MATLAB:nearlySingularMatrix');