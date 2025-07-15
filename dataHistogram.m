function output = dataHistogram(f_generator)
    % the argument `f_generator` is a function, so when
    % running dataHistogram you have to input the function as
    % `dataHistogram(@your_function)` with the @

    [matfile, dir] = uigetfile('*.mat'); % get file and folder
    file = load([dir, matfile]); % load file from that folder
    disp(matfile)

    data = file.data;
    table = file.table;
    initcond = file.initcond;
    generation = file.generation;
    table_params = file.table_params;

    n_ts = generation(1);
    n_iangles = generation(2);
    n_traj = generation(3);

    w = table_params(1);
    r = table_params(2);
    rho = table_params(3);
    delta = table_params(4);

    % get the observable function
    [observe_name, observe] = f_generator(table_params, table);

    n_initcond = numel(data);
    n_iters = size(data{1}, 1);
    
    array = zeros(1, n_initcond);
    for i = 1:n_initcond
        total = 0;
        for j = 1:n_iters - 1
            phi = data{i}(j, 3);
            t = data{i}(j,1);
            piece = data{i}(j,4);
            phi_next = data{i}(j + 1, 3);
            t_next = data{i}(j+1,1);
            piece_next = data{i}(j+1,4);
            if ~isnan(t) && ~isnan(piece) && ~isnan(t_next) && ~isnan(piece_next)
                % adding option for any observable here
                % total = total + f(phi, t, phi_next, t_next)
                % where f is some observable function
                total = total + observe(phi, t, phi_next, t_next);
                % x = table{piece,1}(t);
                % y = table{piece,2}(t);
                % x_next = table{piece_next,1}(t_next);
                % y_next = table{piece_next,2}(t_next);
                % total = total + sqrt((x_next-x)^2+(y_next-y)^2) - tauBar;
            end
        end
        average = total/sqrt(n_iters - 1);
        array(i) = average;
    end

    disp('did averages, doing variance now')
    table_params = [w, r, rho, delta];
    [sigma2s, second_terms] = variance(initcond, generation, data, table, table_params, f_generator);
    sigma2 = sigma2s(end);  % or pick whichever index you want
    %disp(sigma2);

    bin_width = 0.3;
    figure;
    histogram(array, BinWidth=bin_width)
    hold on;
    norml = n_traj * bin_width;
    fplot(@(x)(norml / sqrt(2*pi*sigma2)) * exp(-(x).^2 / (2*sigma2)),[min(array) max(array)]);
    %fplot(@(x)(norml / sqrt(pi*sigma2)) * exp(-(x).^2 / (sigma2)),[min(array) max(array)]);
    %title(sprintf('Delta = %.2f, observable: %s', delta, observe_name));
    title(sprintf('Histogram with f=%s for %d x %d grid (%d attempted, %d successful), w = %d, R = %d, rho = %d, delta = %0.2f', observe_name, n_ts, n_iangles, n_ts * n_iangles, n_traj, w, r, rho, delta));
    xlim([-10, 10])
    ylim([0, 120])
    hold off;

end
