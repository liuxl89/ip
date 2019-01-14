% Which set of tasks to specify for people.

%   - tasks_to_people_file: **initial** value for given tasks;
%   - tasks_to_people: **initial** value for given tasks;
%     e.g. [1, 2, 2, 2, 2, 2; 2, 3, 4, 3, 4, 3] means:
%     * 1st task is assigned to 2nd person on MTWRF;
%     * 2nd task is assigned to 3rd person on MWF and 4th person if TR.


function [tasks_to_people, tasks_to_people_cell] = read_task_person_pairs_cell_csv(
    tasks_to_people_file="task_n_to_people_init.csv", dir="~/Desktop/github/ip/")
  tasks_to_people = read_csv_from_row_n(tasks_to_people_file, dir, 1);
  tasks_to_people_cell = {};

  for row = 1 : rows(tasks_to_people)
    task_to_people = tasks_to_people(row, :);

    people = task_to_people(1, 2 : length(task_to_people));
    distinct_days = length(unique(people));

    filename = sprintf("task_%d_to_people.csv", row);
    % Header length = distinct_days.
    mat = read_csv_from_row_n(filename, dir, distinct_days + 1);

    % Simple case, only one queue for rotation, use it as a mat.
    % Complicated case, multiple queues for rotation, use it as a cell for each
    % week day.
    if rows(mat) == 1
      tasks_to_people_cell{row} = mat;

      % Checks that intial value is valid: queue = mat.
      person = people(1);
      if ~any(mat == person)
	error("Initial value for task %d = %d, does match with that specified in %s.\n",
	      row, person, filename);
      endif
    else
      if rows(mat) != 5
	error("Rows of csv files are either 1 or 5 (as a week): %d (%s).\n",
	      rows(mat), filename);
      endif

      cell = {};
      for mat_row = 1 : rows(mat)
	queue = mat(mat_row, :);
	% There'll be placeholders of 0s, when length for any weekday differs
	% from any other days.
	cell{mat_row} = queue(find(queue));

	% Checks that intial value is valid: queue differs for each day.
	person = people(mat_row);
	if ~any(queue == person)
	  error(["Initial value for task %d = %d (weekday = %d), ", ...
		"doesn't match with that specified in %s.\n"],
		row, person, mat_row, filename);
	endif
      endfor
      tasks_to_people_cell{row} = cell;
    endif
  endfor
endfunction
