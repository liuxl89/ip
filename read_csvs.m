function [people_columns, task_am_columns, task_pm_columns] = read_csvs(
    people_csv="people.csv",
    task_am_columns_csv="tasks_am.csv",
    task_pm_columns_csv="tasks_pm.csv",
    dir="~/Desktop/github/ip/")
  people_columns = csvread([dir, people_csv]);
  task_am_columns = csvread([dir, task_am_columns_csv]);
  task_pm_columns = csvread([dir, task_pm_columns_csv]);

  if (columns(people_columns) ~= columns(task_am_columns) ||
      columns(people_columns) ~= columns(task_pm_columns)) 
      error("Columns of csv files don't match! (%d, %d, %d).",
	    columns(people_columns), columns(task_am_columns),
	    columns(task_pm_columns));
  endif
endfunction