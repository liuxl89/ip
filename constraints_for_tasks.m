% Assuming M_{pt} = M_{p(am, pm)}.


% The most generic constraints:
%  - At most one person for each task, given a half-day.

function [mat_a_le, vec_b_le] = constraints_for_tasks()
  global NUM_PEOPLE;
  global NUM_TASKS_AM;
  global NUM_TASKS_PM;
  global NUM_TASKS;

  lb = zeros(NUM_PEOPLE, NUM_TASKS);

  mat_a_le = [];
  vec_b_le = [];
  for am = 1 : NUM_TASKS_AM
    task_am = lb;
    task_am(1 : NUM_PEOPLE, am) = 1;
    mat_a_le = [mat_a_le; task_am(:)'];
    vec_b_le = [vec_b_le; 1];
  end

  for pm = 1 : NUM_TASKS_PM
    task_pm = lb;
    task_pm(1 : NUM_PEOPLE, pm) = 1;
    mat_a_le = [mat_a_le; task_pm(:)'];
    vec_b_le = [vec_b_le; 1];
  end

endfunction
