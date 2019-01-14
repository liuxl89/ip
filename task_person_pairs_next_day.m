% Which set of tasks to specify for people for the next day.

%  - current_day_of_week: MTWRF;
%  - task_person_pairs_init: [rows, 6], for each weekday, e.g.
%    [t_i, p_i_M, p_i_T, p_i_W, p_i_R, p_i_F;];
%
%  - task_person_pairs_cell: Queues for each task on weekdays. 



function next_task_person_pairs = task_person_pairs_next_day(
    current_day_of_week, task_person_pairs_init, task_person_pairs_cell)
  % By default, it's the same as previous pairs, in case some entries don't
  % need to be updated.
  next_task_person_pairs = task_person_pairs_init;

  for row = 1 : rows(task_person_pairs_init)
    task_person_pair = task_person_pairs_init(row, :);
    task_person_pair_cell_row = task_person_pairs_cell{row};

    % For each weekday, find out the next person.
    for day_of_week = 1 : 5
      % Find out the queue to circulate.
      queue = [];
      if iscell(task_person_pair_cell_row)
	queue = task_person_pair_cell_row{day_of_week};

	if mod(current_day_of_week + day_of_week, 2) ~= 0
	  % Only updates MWF or TR together.
	  continue;
	endif
      else
	% TODO(liuxl): Could optimize for the simplest case, when MTWRF are all
	% the same, i.e. no need to differentiate which day_of_week is.
	queue = task_person_pair_cell_row;
      endif

      current_person = task_person_pair(1 + day_of_week);
      % mod() is to make sure it's a circular queue.
      next_index = find(queue == current_person) + 1;
      if next_index > length(queue)
        next_index -= length(queue);
      endif
      next_person = queue(next_index);

      % First column is task id.
      next_task_person_pairs(row, 1 + day_of_week) = next_person;
    endfor
  endfor
endfunction
