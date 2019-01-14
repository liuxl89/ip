% Assuming M_{pt} = M_{p(am, pm)}.


% They are columnwise goal functions. 
%   - people_columns: people with given skill sets;
%   - task_columns: tasks with recommended skills sets;
%   - task_weights: weights for multiple tasks, default is the same for all.


function vec_c = goal_for_columns(
    people_columns, task_columns, task_weights=ones(rows(task_columns), 1))
  global NUM_PEOPLE;
  global NUM_TASKS;
  lb = zeros(NUM_PEOPLE, NUM_TASKS);
  goal = lb;

  for column = 1 : columns(task_columns)
    task_column = task_columns(:, column);
    selected_tasks = find(task_column);

    % Only need to think about columns with non trivial (!= 0) constraints.
    if ~length(selected_tasks)
      continue;
    endif

    selected_weights = zeros(size(task_weights));
    selected_weights(selected_tasks) = task_weights(selected_tasks);

    people_column = people_columns(:, column);
    goal_for_a_column = lb;
    for selected_task_id = 1 : length(selected_tasks)
      selected_task = selected_tasks(selected_task_id);
      goal_for_a_column(:, selected_task) = people_column;
      goal_for_a_column .*= repmat(selected_weights', NUM_PEOPLE, 1);
    endfor
    goal += goal_for_a_column;
  endfor

  vec_c = goal(:);

endfunction
