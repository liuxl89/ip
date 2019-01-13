clc
clear

% This is to control the global vars.
test = 0;


global NUM_PEOPLE = 38;
global NUM_TASKS_AM = 30;
global NUM_TASKS_PM = 28;
global NUM_TASKS = NUM_TASKS_AM + NUM_TASKS_PM;

if test
  NUM_PEOPLE = 3;
  NUM_TASKS_AM = 2;
  NUM_TASKS_PM = 2;
  NUM_TASKS = NUM_TASKS_AM + NUM_TASKS_PM;
endif


printf("Daily job.\n")
printf("  Number of (people, tasks) = (%d, %d (= %d + %d)).\n",
       NUM_PEOPLE, NUM_TASKS, NUM_TASKS_AM, NUM_TASKS_PM);
printf("  Product = %d.\n\n", NUM_PEOPLE * NUM_TASKS);
fixed_task_pairs = [1];
fixed_task_pairs = [fixed_task_pairs, fixed_task_pairs + NUM_TASKS_AM];

fixed_task_pair_conflicts = [2; 4];

task_person_pairs = [];
cardiology_tasks = [];
cardiology_people = [];

[goal_day, mat_a, vec_b, mat_a_le, vec_b_le, lb, ub] = matrix_for_a_day(
  1,  % Monday.
  fixed_task_pairs, fixed_task_pair_conflicts, task_person_pairs,
  cardiology_tasks, cardiology_people);
  

printf("goal_day    = (%d, %d).\n\n", rows(goal_day), columns(goal_day));

printf("mat_a    = (%d, %d).\n", rows(mat_a), columns(mat_a));
printf("vec_b    = (%d, %d).\n\n", rows(vec_b), columns(vec_b));

printf("mat_a_le = (%d, %d).\n", rows(mat_a_le), columns(mat_a_le));
printf("vec_b_le = (%d, %d).\n\n", rows(vec_b_le), columns(vec_b_le));

printf("lb       = (%d, %d).\n", rows(lb), columns(lb));
printf("ub       = (%d, %d).\n", rows(ub), columns(ub));
