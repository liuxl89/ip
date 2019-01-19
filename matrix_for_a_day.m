% Goal function and constraints for a given day.


function [day_goal, day_weights, ...
	  day_mat_a, day_vec_b, day_mat_a_le, day_vec_b_le, ...
	  day_lb, day_ub] = matrix_for_a_day(
	      day_of_week, task_pairs, task_pair_conflicts, task_person_pairs,
	      cardiology_tasks, cardiology_people,
	      people_columns, task_columns, task_weights)
  global NUM_PEOPLE;
  global NUM_TASKS;
  day_goal = [];
  day_mat_a = [];
  day_vec_b = [];
  day_mat_a_le = [];
  day_vec_b_le = [];
  day_lb = zeros(NUM_PEOPLE, NUM_TASKS)(:);
  day_ub = ones(NUM_PEOPLE, NUM_TASKS)(:);

  % From ppl.
  [mat_a_le, vec_b_le, ub] = constraints_for_people(day_of_week);
  day_mat_a_le = [day_mat_a_le; mat_a_le];
  day_vec_b_le = [day_vec_b_le; vec_b_le];
  day_ub = min(day_ub, ub);


  % From task.
  [mat_a_le, vec_b_le] = constraints_for_tasks();
  day_mat_a_le = [day_mat_a_le; mat_a_le];
  day_vec_b_le = [day_vec_b_le; vec_b_le];


  % Task and/ or people pairs.
  [mat_a, vec_b, mat_a_le, vec_b_le] = constraints_with_pairs(
    task_pairs, task_pair_conflicts, task_person_pairs);
  day_mat_a = [day_mat_a; mat_a];
  day_vec_b = [day_vec_b; vec_b];
  day_mat_a_le = [day_mat_a_le; mat_a_le];
  day_vec_b_le = [day_vec_b_le; vec_b_le];

  % Cardiology group.
  [mat_a, vec_b, mat_a_le, vec_b_le, ub] = constraints_for_cardiology(
    cardiology_tasks, cardiology_people);
  day_mat_a = [day_mat_a; mat_a];
  day_vec_b = [day_vec_b; vec_b];
  day_mat_a_le = [day_mat_a_le; mat_a_le];
  day_vec_b_le = [day_vec_b_le; vec_b_le];
  day_ub = min(day_ub, ub);

  % Goal function from columnwise requirements.
  [day_goal, day_weights] = goal_for_columns(
      people_columns, task_columns, task_weights);

endfunction
