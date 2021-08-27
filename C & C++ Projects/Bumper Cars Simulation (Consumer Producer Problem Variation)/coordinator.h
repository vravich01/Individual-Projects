/** Header file is based on a design provided by NCSU CSC Department */

/** Initial value for nextCarIn, so the program can set this up the first time */
#define INITIAL_VAL -1
/** Special value for car buffer to indicate empty slot */
#define SPECIAL_VAL -10

/** Struct for multithreading arguments (rider ID) */
typedef struct
{
    int riderId;
} Param;

/**
 * @brief Simulates a rider waiting for an available car and taking it when it becomes ready.
 * 
 * @param riderId The ID of the rider wanting a car
 * @return int The ID of the car taken by the rider
 */
int getInLine(int riderId);

/**
 * @brief Simulates a rider returning a car to become available for others.
 * 
 * @param riderId The ID of the rider returning the car
 * @param carId The ID of the car returned by the rider
 */
void returnCar(int riderId, int carId);

//Confirmation that I'm downloading the most recent version of this file from remote school servers
