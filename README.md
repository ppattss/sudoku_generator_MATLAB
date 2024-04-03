# sudoku_matlab
Sudoku generator and solver. 

Originally developed for desktop MATLAB r2018a, has tested on current build of matlab web editor (https://matlab.mathworks.com/).

Any feedback and/or contributions are welcome.


Release notes:
    - Current implementation is a prototype, significant optimization is still required.
    - All functions are self-contained within the 'sudokuSinglePage.m' program
    - Logic is brute force generation of 9 grid squares, starting form top left, each grid with 9 numbers. 
    - Program will attempt to solve in a linear fashion starting from top left.
    - Program will backtrack to previous grids if no valid solutions are found.
    - New valid solutions are added to the csv file.
    - CSV file is cloned prior to adding new solutions


Solution example:
    6	3	7	1	8	9	4	2	5
    8	5	1	4	7	2	9	3	6
    2	4	9	3	5	6	1	8	7
    3	1	6	2	4	8	5	7	9
    4	7	8	5	9	3	6	1	2
    5	9	2	7	6	1	8	4	3
    9	2	3	6	1	4	7	5	8
    7	6	4	8	2	5	3	9	1
    1	8	5	9	3	7	2	6	4
