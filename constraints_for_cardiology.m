% Assuming M_{pt} = M_{p(am, pm)}.

% They are all generic (equality & inequality) constraints.
%  - cardiology_tasks, cardiology_people: relatively independent.


function [mat_a, vec_b, mat_a_le, vec_b_le, ub] = constraints_for_cardiology(
    cardiology_tasks, cardiology_people)
  global NUM_PEOPLE;
  global NUM_TASKS;
  lb = zeros(NUM_PEOPLE, NUM_TASKS);

  mat_a = [];
  vec_b = [];
  mat_a_le = [];
  vec_b_le = [];


  % Dedicated and backup cardiology people: no other people should be assigned.
  ub = ones(size(lb));
  non_cardiology_people = setdiff(1 : NUM_PEOPLE, cardiology_people);
  ub(non_cardiology_people, cardiology_tasks) = 0;
  ub = ub(:);

endfunction
