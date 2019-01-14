function mat = read_csv_from_row_n(filename, dir="~/Desktop/github/ip/", from_row=2)
  mat = csvread([dir, filename]);
  mat = mat(from_row : rows(mat), :);
endfunction
