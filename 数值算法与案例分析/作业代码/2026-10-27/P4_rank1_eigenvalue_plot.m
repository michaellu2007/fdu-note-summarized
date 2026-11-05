% 1. 随机生成数据
rng(1); % 设置随机种子，保证每次运行结果一致（可删去）
n = 6; 
% 生成 n 个互不相同的 d_i (使用 randperm 保证不重复)
d = randperm(20, n)'; 
d = sort(d); % 排序，方便画图观察
% 生成 z，保证没有 0 元素
z = rand(n, 1) + 0.5; 

% 2. 构造矩阵 A
D = diag(d);         % 对角矩阵
A = D + z * z';      % z*z' 是列向量乘行向量，得到外积矩阵

% 3. 计算 A 的特征值
eigenvalues = eig(A); 
eigenvalues = sort(eigenvalues); % 排序对比

% 4. 定义函数 f(lambda)
% 使用匿名函数 (Anonymous Function)
f = @(lambda) 1 - sum((z.^2) ./ (lambda - d));

% 5. 绘制图像
figure;
hold on;

% --- 新增：画最左侧区间 (-∞, d_1) ---
lam_left = linspace(d(1) - 5, d(1) - 0.01, 500);
plot(lam_left, f(lam_left), 'b-', 'LineWidth', 1.5);

% --- 画中间的各区间 (d_i, d_{i+1}) ---
for i = 1:(n-1)
    lam_range = linspace(d(i) + 0.01, d(i+1) - 0.01, 500);
    plot(lam_range, f(lam_range), 'b-', 'LineWidth', 1.5);
end

% --- 画最右侧区间 (d_n, +∞) ---
lam_right = linspace(d(n) + 0.01, d(n) + 5, 500);
plot(lam_right, f(lam_right), 'b-', 'LineWidth', 1.5);

% 绘制垂直渐近线 (x = d_i)
for i = 1:n
    xline(d(i), 'k--', 'LineWidth', 1); 
end

% 绘制水平线
yline(0, 'k-', 'LineWidth', 1);         % y=0 基准线
yline(1, 'm--', 'LineWidth', 1.5);      % y=1 水平渐近线 (-∞ 和 +∞ 都趋向于它)

% 绘制特征值点 (标记在 y=0 上)
plot(eigenvalues, zeros(size(eigenvalues)), 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 8);

% 调整坐标轴范围
ylim([-5, 5]);
xlim([min(d)-5, max(d)+5]); % 注意这里 xlim 也跟着左移了一点，为了显示完整左侧
title('Visualization of f(\lambda) and Eigenvalues of A');
xlabel('\lambda');
ylabel('f(\lambda)');

% 图例
legend('f(\lambda)', '垂直渐近线 (d_i)', 'y=0 基准线', 'y=1 水平渐近线', 'A 的特征值', 'Location', 'best');

grid on;
hold off;