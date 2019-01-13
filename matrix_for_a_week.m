% Goal function and constraints for a given week, or to be more accurate, for
% any specified number of days.

%   - days: Number of days to work on;
%     - days = 5: weekly matrices;
%     - days = 1: falls back to daily matrices.
%   
%   - work_load_ranges: work load ranges for ppl [...; p_i, wi_min, wi_max; ...];
%     - work load for person p_i is in the range of [wi_min, wi_max];


function [week_goal, week_mat_a, week_vec_b, week_mat_a_le, week_vec_b_le, ...
	  week_lb, week_ub] = matrix_for_a_week(
	      day_of_week, days, fixed_task_pairs, fixed_task_pair_conflicts,
	      init_task_person_pairs, cardiology_tasks, cardiology_people,
	      people_columns, task_columns, task_weights,
	      work_load_ranges = [26, 0, 0.5])
  global NUM_PEOPLE;
  global NUM_TASKS;
  DAYS_PER_WEEK = 5;
  MIN_WORK_LOAD = 0;
  MAX_WORK_LOAD = 0;

  dimension_for_day = NUM_PEOPLE * NUM_TASKS;
  dimension_for_week = dimension_for_day * days;
  week_goal = [];
  week_mat_a = [];
  week_vec_b= []; 
  week_mat_a_le = [];
  week_vec_b_le = [];
  week_lb = [];
  week_ub = [];

  task_person_pairs = init_task_person_pairs;  % TODO(liuxl).
  for day = 1 : days
    % Augments all weekly matrices.
    [day_goal, day_mat_a, day_vec_b, day_mat_a_le, day_vec_b_le, ...
     day_lb, day_ub] = matrix_for_a_day( ...
	 mod(day_of_week+ day - 1, DAYS_PER_WEEK), fixed_task_pairs, ...
	 fixed_task_pair_conflicts, task_person_pairs, ...
	 cardiology_tasks, cardiology_people,
	 people_columns, task_columns, task_weights);

    [week_mat_a, week_vec_b] = update_mat(week_mat_a, week_vec_b,
					  day_mat_a, day_vec_b);
    [week_mat_a_le, week_vec_b_le] = update_mat(week_mat_a_le, week_vec_b_le,
						day_mat_a_le, day_vec_b_le);
    week_goal = update_vec(week_goal, day_goal);
    week_lb = update_vec(week_lb, day_lb);
    week_ub = update_vec(week_ub, day_ub);

    % Generates the next task_person_pairs, until the last day.
    if day != days
      task_person_pairs = init_task_person_pairs;  % TODO(liuxl).
    endif
  endfor

  % Sets up max work load limits for given people.
  lb = zeros(NUM_PEOPLE, NUM_TASKS);
  for row = 1 : rows(work_load_ranges)
    work_load_range_for_person = work_load_ranges(row, :);
    person =  work_load_range_for_person(1);

    indices = lb;
    indices(person, :) = 1;
    indices = indices(:)';

    min_work_load =  work_load_range_for_person(2);
    if min_work_load > MIN_WORK_LOAD
      min_work_load_in_half_days = round(days * 2 * min_work_load);
      mat_a_le = [mat_a_le; -indices];
      vec_b_le = [vec_b_le; -min_work_load_in_half_days];
    endif

    max_work_load =  work_load_range_for_person(3);
    if max_work_load < MAX_WORK_LOAD
      max_work_load_in_half_days = round(days * 2 * max_work_load);
      mat_a_le = [mat_a_le; indices];
      vec_b_le = [vec_b_le; max_work_load_in_half_days];
    endif
  endfor

endfunction


function vec = update_vec(old_vec, new_vec)
   vec = [old_vec; new_vec];
endfunction

function [mat_a, vec_b] = update_mat(old_mat_a, old_vec_b, new_mat_a, new_vec_b)
   vec_b = update_vec(old_vec_b, new_vec_b);

   [old_rows, old_cols] = size(old_mat_a);
   [new_rows, new_cols] = size(new_mat_a);
   num_rows = old_rows + new_rows;
   num_cols = old_cols + new_cols;
   mat_a = zeros(num_rows, num_cols);
   mat_a(1 : old_rows, 1 : old_cols) = old_mat_a;
   mat_a((old_rows + 1) : num_rows, (old_cols + 1) : num_cols) = new_mat_a;

endfunction
