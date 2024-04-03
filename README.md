# sudoku_matlab
Sudoku generator and solver. 

Developed for desktop MATLAB r2018a, tested on current build of matlab web editor (https://matlab.mathworks.com/).

  - Current implementation is a proof of concept/prototype, significant optimization is still required.
  - All functions are self-contained within the 'sudokuSinglePage.m' program
  - Logic is brute force generation of 9 grid squares, starting form top left, each grid with 9 numbers. 
  - Program will attempt to solve in a linear fashion starting from top left.
  - Program will backtrack to previous grids if no valid solutions are found.
  - New valid solutions are added to the csv file.
  - CSV file is cloned prior to adding new solutions
