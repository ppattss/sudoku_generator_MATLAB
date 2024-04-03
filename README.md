# sudoku_matlab
Sudoku generator and solver. 

Originally developed for desktop MATLAB r2018a, tested successfully on current build of matlab web editor (https://matlab.mathworks.com/).

Any feedback and/or contributions are welcome.

TO DO LIST:
- Add validation check for solutions prior to saving, (currently, invalid solutions that reach backtracking limit as saved).
- Fix helper functions.

Release notes:
- Current implementation is a prototype, significant optimization is still required.
- All functions are self-contained within the 'sudokuSinglePage.m' program.
- Debug logging in command window for progress of each step.
- Logic is brute force generation of 9 grid squares, starting form top left.
- Each grid has a unique series of numbers 1 to 9. 
- Program will attempt to solve in a linear fashion starting from top left.
- Program will backtrack to previous grids if no valid solutions are found.
- If backtrack limit is exceeded, program will exit.
- New valid solutions are added to the solutions csv file.
- CSV file is cloned prior to adding new solutions.


<img width="378" alt="Screenshot 2024-04-03 at 2 00 50 pm" src="https://github.com/ppattss/sudoku_matlab/assets/42530595/fe800108-3394-4d4a-aa7f-7c99dd87d370">
