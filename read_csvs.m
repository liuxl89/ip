function [people_columns, task_am_columns, task_pm_columns] = read_csvs(
    people_csv="people.csv",
    task_am_columns_csv="tasks_am.csv",
    task_pm_columns_csv="tasks_pm.csv",
    dir="~/Desktop/github/ip/")
  people_columns = read_csv_from_row_n(people_csv, dir);
  task_am_columns = read_csv_from_row_n(task_am_columns_csv, dir);
  task_pm_columns = read_csv_from_row_n(task_pm_columns_csv, dir);

  if (columns(people_columns) ~= columns(task_am_columns) ||
      columns(people_columns) ~= columns(task_pm_columns)) 
      error("Columns of csv files don't match! (%d, %d, %d).",
	    columns(people_columns), columns(task_am_columns),
	    columns(task_pm_columns));
  endif

  num_columns = columns(people_columns);
  % Removes the first column, as they're the index for each person or task.
  people_columns = people_columns(:, 2 : num_columns);
  task_am_columns = task_am_columns(:, 2 : num_columns);
  task_pm_columns = task_pm_columns(:, 2 : num_columns);
endfunction
