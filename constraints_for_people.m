% Assuming M_{pt} = M_{p(am, pm)}.


% The most generic constraints:
%  - At most one task for a person, given a half-day;
%  - Out on Thursdays.


function [mat_a_le, vec_b_le, ub] = constraints_for_people(day_of_week = 0)
  global NUM_PEOPLE;
  global NUM_TASKS_AM;
  global NUM_TASKS_PM;
  global NUM_TASKS;

  lb = zeros(NUM_PEOPLE, NUM_TASKS); 

  % Starts with an empty (A, b), and keep populating it for each person.
  mat_a_le = [];
  vec_b_le = [];
  for person = 1 : NUM_PEOPLE
    person_am = lb;
    person_am(person, 1: NUM_TASKS_AM) = 1;

    person_pm = lb;
    person_pm(person, (NUM_TASKS_AM + 1) : NUM_TASKS) = 1;

    mat_a_le = [mat_a_le; person_am(:)'; person_pm(:)'];
    vec_b_le = [vec_b_le; 1; 1]; 
  end

  % Always out of office on Thursday.
  ub = ones(size(lb));
  if day_of_week == 4
    ub(28, :) = 0;
  endif
  ub = ub(:);

endfunction
