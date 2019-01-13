% Assuming M_{pt} = M_{p(am, pm)}.


% They are all generic (equality & inequality) constraints.
%  - task_pairs (assigned to same person): [t_01, t_01'; t_02, t_02'; ...];
%    e.g. [1, 31; 2, 32] means:
%      * am_01 == pm_01;
%      * am_02 == pm_02;

%  - task_person_pair: [t_01, p_01; t_02, t_02; ...];
%    e.g. [1, 10; 32, 20] means:
%      * am_01 assigned to 10th person;
%      * pm_02 (32th task with 30 tasks in the morning) assigned to the 20th
%        person.

%  - task_pair_conflicts (assigned to different person):
%    [t_01, t_01'; t_02, t_02'; ...];
%    e.g. [9, 41; 10, 42] means:
%      * am_09 != pm_11;
%      * am_10 != pm_12.


function [mat_a, vec_b, mat_a_le, vec_b_le] = constraints_with_pairs(
    task_pairs, task_pair_conflicts, task_person_pairs)
  global NUM_PEOPLE;
  global NUM_TASKS;
  lb = zeros(NUM_PEOPLE, NUM_TASKS);

  % Task pairs to the same person.
  mat_a = [];
  for row = 1 : rows(task_pairs)
    task_pair = task_pairs(row, :);

    for person = 1 : NUM_PEOPLE
      indices = lb;
      indices(person, task_pair(1)) = 1;
      indices(person, task_pair(2)) = -1;

      mat_a = [mat_a; indices(:)'];
    end
  end
  vec_b = zeros(rows(mat_a), 1);

  % Task to a given person.
  mat_a_new = [];
  vec_b_new = [];
  for row = 1 : rows(task_person_pairs)
    task_person_pair = task_person_pairs(row, :);

    indices = lb;
    indices(task_person_pair(2), task_person_pair(1)) = 1;

    mat_a_new = [mat_a; indices(:)'];
    vec_b_new = [vec_b_new; 1]; 
  end
  mat_a = [mat_a; mat_a_new];
  vec_b = [vec_b; vec_b_new];

  % Task pairs to different people.
  mat_a_le = [];
  for row = 1 : rows(task_pair_conflicts)
    task_pair_conflict = task_pair_conflicts(row, :);

    for person = 1 : NUM_PEOPLE
      indices = lb;
      indices(person, task_pair_conflict) = 1;
      mat_a_le = [mat_a_le; indices(:)'];
    end
  end
  vec_b_le = ones(rows(mat_a_le), 1);

endfunction
