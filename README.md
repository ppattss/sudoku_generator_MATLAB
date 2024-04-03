# sudoku_matlab
Sudoku generator and solver. 

Developed for desktop MATLAB r2018a, tested on current build of matlab web editor (https://matlab.mathworks.com/).

  - Logic is brute force generation of 9 grid squares, each with 9 numbers. 
  - Program will attempt to solve in a linear fashion starting from top left.
  - Program will backtrack to previous grids if no valid solutions are found.
  - New valid solutions are added to the csv file.
  - CSV file is cloned prior to adding new solutions
