clear; clc;
n = 1000; 
D = diag(randn(n, 1) + 1i * randn(n, 1)); 
P = randn(n, n) + 1i * randn(n, n);
A = P * D / P; 
exact_exp = P * exp(D) / P;
approx_exp_mine = my_expm_taylor(A);
built_in_exp = expm(A);
err_mine = norm(approx_exp_mine - exact_exp, 2) / norm(exact_exp, 2);
err_builtin = norm(built_in_exp - exact_exp, 2) / norm(exact_exp, 2);

fprintf('==== 准确度测试结果 ====\n');
fprintf('矩阵维度 n = %d\n', n);
fprintf('自定义 Scaling-Taylor 算法相对误差: %e\n', err_mine);
fprintf('MATLAB 内置 expm 相对误差:         %e\n', err_builtin);
fprintf('========================\n');
function E = my_expm_taylor(A)
    [n, m] = size(A);
    if n ~= m
        error('输入必须是方阵');
    end
    
    % Scaling (缩放)
    norm_A = norm(A, 1); 
    theta = 0.5;         
    if norm_A > theta
        s = ceil(log2(norm_A / theta));
    else
        s = 0;
    end
    
    B = A / (2^s);
    
    %  Truncated Taylor Series 
    E = eye(n);
    term = eye(n);
    k = 1;
    tol = 1e-16;       
    max_iter = 100;    
    
    while k <= max_iter
        term = term * B / k;
        E = E + term;
        
        % 检查截断条件：如果当前项的范数相比于总和的范数极小，则停止
        if norm(term, 1) < tol * norm(E, 1)
            break;
        end
        k = k + 1;
    end
    for i = 1:s
        E = E * E;
    end
end