#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <stdlib.h>
#include <string.h>
#include <pthread.h>

#define DEAD 0
#define ALIVE 1

#define MIN 2
#define MAX 3
#define TARGET 3

#define PAD 2

/** Psuedocode provided by NCSU CSC Department */

/**
 * Struct that contains neccesary arguments for thread creation.
 */
typedef struct ParamPack
{
    int i;        //Current row
    int j;        //Current col
    int ** grid;  //Grid
    int ** gridW; //Wrappper grid
} ParamPack;

/**
 * Creates a 2D array of parameter packages for multithreading.
 */
ParamPack ** makeParamPack(int rows, int cols, int ** grid, int ** gridW)
{
    //Allocates heap memory for 2D array
    ParamPack ** params = (ParamPack **) malloc(rows * sizeof(ParamPack *));
    for (int i = 0; i < rows; i++) {
        params[i] = (ParamPack *) malloc(cols * sizeof(ParamPack));
    }

    //Sets values and returns
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            params[i][j].i = i;
            params[i][j].j = j;
            params[i][j].grid = grid;
            params[i][j].gridW = gridW;
        }
    }
    return params;
}

/**
 * Frees the heap memory for a list of ParamPacks.
 */
void freeParamPack(int rows, ParamPack ** params)
{
    //Frees each row of pointers
    for (int i = 0; i < rows; i++) {
        free(params[i]);
    }

    //Frees overall pointer
    free(params);
}


/**
 * Creates a 2D array of integers representing cells.
 */
int ** makeGrid(int rows, int cols)
{
    //Allocates heap memory for 2D array
    int ** grid = (int **) malloc(rows * sizeof(int *));
    for (int i = 0; i < rows; i++) {
        grid[i] = (int *) malloc(cols * sizeof(int));
    }
    return grid;
}

/**
 * Prints a grid of cells.
 */
void printGrid(int gen, int rows, int cols, int ** grid)
{
    //Prints header for this generation
    printf("Gen#%d\n", gen);

    //Prints grid for this generation
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            printf("%d", grid[i][j]);
            if (j != cols - 1) {
                printf(" ");
            }
        }
        printf("\n");
    }
    printf("\n");
}

/**
 * Copies the current generation to the wrapper grid which
 * is used to decide the next generation cells (which are later
 * updated on the regular grid).
 */
void copyGridToWrapper(int rows, int cols, int ** grid, int ** gridW)
{
    //Internal
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            gridW[i + 1][j + 1] = grid[i][j];
        }
    }

    //Sides
    for (int i = 0; i < rows; i++) {
        gridW[i + 1][0] = gridW[i + 1][cols];
        gridW[i + 1][cols + 1] = gridW[i + 1][1];
    }

    //Top and bottom
    for (int j = 0; j < cols; j++) {
        gridW[0][j + 1] = gridW[rows][j + 1];
        gridW[rows + 1][j + 1] = gridW[1][j + 1];
    }

    //Corners
    gridW[0][0] = gridW[rows][cols];
    gridW[0][cols + 1] = gridW[rows][1];
    gridW[rows + 1][cols + 1] = gridW[1][1];
    gridW[rows + 1][0] = gridW[1][cols];
}

/**
 * Decides the next generation of cells.
 */
int decideNextGen(int i, int j, int ** grid)
{
    //Counts number of alive neighbors
    int count = 0;
    for (int p = -1; p <= 1; p++) {
        for (int q = -1; q <= 1; q++) {
            if (grid[i + p][j + q] == 1) {
                count++;
            }
        }
    }

    //If this cell is alive, kills it unless it has 2 or 3 alive neighbors
    if (grid[i][j] == ALIVE) {
        count--;
        if (count == MIN || count == MAX) {
            return ALIVE;
        } else {
            return DEAD;
        }
    //If this cell is dead, resurrects it if it has 3 alive neighbors
    } else if (grid[i][j] == DEAD) {
        if (count == TARGET) {
            return ALIVE;
        } else {
            return DEAD;
        }
    //This should not happen, something definitely got screwed up lol
    } else {
        printf("Cell corruption error...\nFound: \"%d\" (must be 0 or 1)\n", grid[i][j]);
        exit(1);
    }
}

/**
 * Updates the current generation of cells to become the next.
 * This function acts as an intermediary where the thread params
 * are "unpacked" before used to update the cell.
 */
void * updateCell(void * param)
{
    //Unpacking the thread arguments
    ParamPack * paramptr = (ParamPack *) param; 
    int i = paramptr->i;
    int j = paramptr-> j;
    int ** grid = paramptr->grid;
    int ** gridW = paramptr->gridW;

    //Updates this cell (i, j) by making a decision using the wrapper grid
    grid[i][j] = decideNextGen(i + 1, j + 1, gridW);

    //Exits thread
    pthread_exit(0);
}

/**
 * Frees the heap memory for a grid.
 */
void freeGrid(int rows, int ** grid)
{
    //Frees each row of pointers
    for (int i = 0; i < rows; i++) {
        free(grid[i]);
    }

    //Frees overall pointer
    free(grid);
}


/**
 * Game of Life... 
 */
int main(int argc, char ** argv)
{
    //Check program argument count
    if (argc != TARGET) {
        printf("Invalid program args...\nusage: ./<program> <filename> <generations>\n");
        exit(1);
    }

    //Open input file in write mode
    FILE * inputFile = fopen(argv[argc - 2], "r");
    if (!inputFile) {
        printf("Input file not found or not accessible...\n");
        exit(1);
    }

    //Read number of generations to simulate
    int totalGens = atoi(argv[argc - 1]);
    if (totalGens <= 0) {
        printf("Number of generations not interpretable...\n");
        exit(1);
    }

    //Set up standard vars
    int rows, cols, scan;

    //Read row count
    scan = fscanf(inputFile, "%d", &rows);
    if (scan != 1) {
        printf("Input file header not formatted correctly...\n");
        exit(1);
    }

    //Read col count
    scan = fscanf(inputFile, "%d", &cols);
    if (scan != 1) {
        printf("Input file header not formatted correctly...\n");
        exit(1);
    }

    //Create a grid to populate
    int ** grid = makeGrid(rows, cols);

    //Populate grid with gen 0 data from input file
    int cell;
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            scan = fscanf(inputFile, "%d", &cell);
            if (scan != 1) {
                printf("Input file cell (R%d, C%d) not formatted correctly...\n", i, j);
                exit(1);
            }
            grid[i][j] = cell;
        }
    }

    //Close input file
    fclose(inputFile);

    //Create a wrapper grid to make next gen decisions
    int ** gridW = makeGrid(rows + PAD, cols + PAD);

    //Print gen 0
    printGrid(0, rows, cols, grid);

    //Prepare for multithreading
    ParamPack ** params = makeParamPack(rows, cols, grid, gridW);
    pthread_t tid[rows][cols];
    pthread_attr_t attr;
    pthread_attr_init(&attr);

    //Simulate "Life" for totalGens generations
    for (int n = 1; n <= totalGens; n++) {
        //Copy current gen grid to wrapper grid
        copyGridToWrapper(rows,  cols, grid, gridW);
        //Create a thread for each cell, it will decide/update its next gen value
        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                pthread_create(&(tid[i][j]), &attr, updateCell, &(params[i][j]));
            }
        }
        //Wait for threads to exit
        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                pthread_join(tid[i][j], NULL);
            }
        }
        //Prints the new generation grid
        printGrid(n, rows, cols, grid);
    }

    //Clean up heap data because C isn't Java
    freeParamPack(rows, params);
    freeGrid(rows, grid);
    freeGrid(rowsW, gridW);
    exit(EXIT_SUCCESS);
}
