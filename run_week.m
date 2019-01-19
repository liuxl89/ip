clear
clc

% This is to control the global vars.
test = 0;
num_days_to_run = 5;

if num_days_to_run == 1
  clc
endif

global NUM_PEOPLE = 38;
global NUM_TASKS_AM = 30;
global NUM_TASKS_PM = 28;
global NUM_TASKS = NUM_TASKS_AM + NUM_TASKS_PM;
global NUM_COLUMNS = 19;

if test
  NUM_PEOPLE = 3;
  NUM_TASKS_AM = 2;
  NUM_TASKS_PM = 2;
  NUM_TASKS = NUM_TASKS_AM + NUM_TASKS_PM;
  NUM_COLUMNS = 3;
endif


printf("Weekly job.\n")
printf("  Number of (people, tasks) = (%d, %d (= %d + %d)).\n",
       NUM_PEOPLE, NUM_TASKS, NUM_TASKS_AM, NUM_TASKS_PM);
printf("  Product = %d.\n\n", NUM_PEOPLE * NUM_TASKS);

% AM & PM should be the same person.
fixed_task_pairs = [1; 2];
fixed_task_pairs = [fixed_task_pairs, fixed_task_pairs + NUM_TASKS_AM];

% AM & PM should be different people.
fixed_task_pair_conflicts = [9; 10];
fixed_task_pair_conflicts = [fixed_task_pair_conflicts, [11; 12] + NUM_TASKS_AM];

% Specified people for tasks.
task_person_pairs_init_file = "task_n_to_people_init.csv";
[task_person_pairs, tasks_to_people_cell] = read_task_person_pairs_cell_csv(
  task_person_pairs_init_file);
printf("task_person_pairs = (%d, %d).\n",
       rows(task_person_pairs), columns(task_person_pairs));
printf("tasks_to_people_cell = (%d, %d).\n",
       rows(tasks_to_people_cell), columns(tasks_to_people_cell));

cardiology_tasks = [];
cardiology_people = [];


% Columns.
task_weights = ones(NUM_TASKS, 1);
if test
  people_columns = zeros(NUM_PEOPLE, NUM_COLUMNS);
  task_columns = zeros(NUM_TASKS, NUM_COLUMNS);
else
  [people_columns, task_am_columns, task_pm_columns] = read_csvs();
  task_columns = [task_am_columns; task_pm_columns];
  printf("task_am_columns = (%d, %d).\n", rows(task_am_columns), columns(task_am_columns));
  printf("task_pm_columns = (%d, %d).\n", rows(task_pm_columns), columns(task_pm_columns));
endif
printf("people_columns  = (%d, %d).\n", rows(people_columns), columns(people_columns));
printf("task_columns  = (%d, %d).\n", rows(task_columns), columns(task_columns));

%
% Compute all matrices for given days.
%
[goal_week, sum_weights_week, ...
 mat_a, vec_b, mat_a_le, vec_b_le, lb, ub] = matrix_for_a_week(
  1,  % Monday.
  num_days_to_run,
  fixed_task_pairs, fixed_task_pair_conflicts,
  task_person_pairs, tasks_to_people_cell,
  cardiology_tasks, cardiology_people,
  people_columns, task_columns, task_weights);
  

printf("goal_week    = (%d, %d).\n\n", rows(goal_week), columns(goal_week));

printf("mat_a    = (%d, %d).\n", rows(mat_a), columns(mat_a));
printf("vec_b    = (%d, %d).\n\n", rows(vec_b), columns(vec_b));

printf("mat_a_le = (%d, %d).\n", rows(mat_a_le), columns(mat_a_le));
printf("vec_b_le = (%d, %d).\n\n", rows(vec_b_le), columns(vec_b_le));

printf("lb       = (%d, %d).\n", rows(lb), columns(lb));
printf("ub       = (%d, %d).\n", rows(ub), columns(ub));

% U: Ax <= b;  (*)
% S: Ax = b;   (*)
% L: Ax >= b.
ctype = [repelem("S", 1, length(vec_b)), repelem("U", 1, length(vec_b_le))];
vartype = repelem("I", 1, length(lb));
opt_type = -1; % maximization problem.

combined_mat_a = [mat_a; mat_a_le];
combined_vec_b = [vec_b; vec_b_le];
[opt, fmax, errnum, extra] = glpk(
    goal_week,
    combined_mat_a,
    combined_vec_b,
    lb, ub,
    ctype, vartype, opt_type);
    
printf("opt      = (%d, %d).\n", rows(opt), columns(opt));
printf("(Goal, errnum) = (%g (<= %d), %g).\n", fmax, sum_weights_week, errnum);
extra
