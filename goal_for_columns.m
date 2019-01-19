% Assuming M_{pt} = M_{p(am, pm)}.


% They are columnwise goal functions.
%   - people_columns: people with given skill sets;
%   - task_columns: tasks with recommended skills sets;
%   - task_weights: weights for multiple tasks, default is the same for all.


function [vec_c, sum_weights] = goal_for_columns(
    people_columns, task_columns, task_weights=ones(rows(task_columns), 1))
  global NUM_PEOPLE;
  global NUM_TASKS;
  global NUM_TASKS_AM;
  global NUM_TASKS_PM;
  global PRIORITY_FACTOR;

  lb = zeros(NUM_PEOPLE, NUM_TASKS);
  goal = lb;

  % When task_weights are all zeros, it means something special.
  %   - In the morning, the n_th job has a weight of 2^(NUM_TASKS_AM - n);
  %     i.e. 2^(#AM), 2^(#AM - 1), ... 1;
  %   - In the afternoon, it's the same.
  %
  %   - Another manipulation is that the top one task in the morning and in the
  %     afternoon should have the same weight.
  sum_weights = sum((repmat(task_weights, 1, columns(task_columns)) .*
		     task_columns)(:));
  if (sum_weights == 0)
    NUM_TASKS_XM = max(NUM_TASKS_AM, NUM_TASKS_PM);
    task_weights(1 : NUM_TASKS_AM, :) = PRIORITY_FACTOR.^(
	NUM_TASKS_XM - [1 : NUM_TASKS_AM]);
    task_weights([1 : NUM_TASKS_PM] + NUM_TASKS_AM, :) = PRIORITY_FACTOR.^(
	NUM_TASKS_XM - [1 : NUM_TASKS_PM]);

    sum_weights = sum((repmat(task_weights, 1, columns(task_columns)) .*
		       task_columns)(:));
  endif

  for column = 1 : columns(task_columns)
    task_column = task_columns(:, column);
    selected_tasks = find(task_column);

    % Only need to think about columns with non trivial (!= 0) constraints.
    if ~length(selected_tasks)
      continue;
    endif

    % Contains the indicator function already.
    selected_weights = zeros(size(task_weights));
    selected_weights(selected_tasks) = task_weights(selected_tasks);

    people_column = people_columns(:, column);
    goal += people_column * selected_weights';
  endfor

  vec_c = goal(:);

endfunction
