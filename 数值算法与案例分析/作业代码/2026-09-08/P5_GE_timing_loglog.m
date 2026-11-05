clear; clc; close all;

n_list = [100, 150, 200, 300, 400, 600, 800, 1000, 1200, 1600, 2000, 2400];
repeat_list = [20, 20, 15, 10, 8, 5, 4, 3, 3, 2, 2, 1];
time_list = zeros(size(n_list));

gaussian_elimination(randn(50,50), randn(50,1));

for idx = 1:length(n_list)
    n = n_list(idx);
    repeat = repeat_list(idx);
    t_sum = 0;
    
    for r = 1:repeat
        A = randn(n, n);
        b = randn(n, 1);
        
        tic;
        x = gaussian_elimination(A, b);
        t_sum = t_sum + toc;
    end
    
    time_list(idx) = t_sum / repeat;
    fprintf('n = %4d, time = %.6f s\n', n, time_list(idx));
end

save('timing_data.mat', 'n_list', 'time_list');

loglog(n_list, time_list, 'o-', 'LineWidth', 1.5, 'MarkerSize', 8);
hold on;

p = polyfit(log(n_list), log(time_list), 1);
fit_line = exp(p(2)) * n_list.^p(1);
loglog(n_list, fit_line, 'r--', 'LineWidth', 1.5);

xlabel('n');
ylabel('time (s)');
title(sprintf('slope = %.2f', p(1)));
legend('measured', 'fit');
grid on;

fprintf('slope = %.3f\n', p(1));


function x = gaussian_elimination(A, b)
    n = length(b);
    
    for k = 1:n-1
        for i = k+1:n
            factor = A(i,k) / A(k,k);
            A(i, k+1:n) = A(i, k+1:n) - factor * A(k, k+1:n);
            b(i) = b(i) - factor * b(k);
        end
    end
    
    x = zeros(n, 1);
    for i = n:-1:1
        x(i) = (b(i) - A(i, i+1:n) * x(i+1:n)) / A(i,i);
    end
end