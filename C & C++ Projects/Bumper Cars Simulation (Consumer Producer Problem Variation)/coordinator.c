#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <pthread.h>
#include <semaphore.h>

/** Contains simulateRider() */
#include "rider.h"
/** Contains Param struct, getInLine(), and returnCar() */
#include "coordinator.h"

//Sempahores
sem_t mutex, empty, full;

//Global variables for shared memory buffer
int * cars;
int numCars, nextCarIn, nextCarOut;

//Number for output format padding
int numThreadsDigitCount;

//Documented in header
int getInLine(int riderId)
{
    //Wait for number of full slots to be > 0, then lock before moving onto critical code
    sem_wait(&full);
    sem_wait(&mutex);

    //Aquire car
    int carId = cars[nextCarOut];
    cars[nextCarOut] = SPECIAL_VAL;
    nextCarOut = (nextCarOut + 1) % numCars;
    printf("Rider %*d is aquiring car %d\n", numThreadsDigitCount, riderId, carId);

    //Unlock, then signal that one more slot has become empty
    sem_post(&mutex);
    sem_post(&empty);

    //Return car ID
    return carId;
}

//Documented in header
void returnCar(int riderId, int carId)
{
    //Wait for number of empty slots to be > 0, then lock
        //Waiting for empty is not needed, since this function only happens after a car is taken
        //Seems good to include anyway, for consistency, since this is a variant of the consumer-producer problem
    sem_wait(&empty);
    sem_wait(&mutex); 

    //Initial set up for nextCarIn
    if (nextCarIn == INITIAL_VAL) {
        int i = nextCarOut;
        while (cars[i] != SPECIAL_VAL) {
            i = (i + 1) % numCars;
        }
        nextCarIn = i;
    }
    //Return car
    cars[nextCarIn] = carId;
    nextCarIn = (nextCarIn + 1) % numCars;
    printf("Rider %*d is returning car %d\n", numThreadsDigitCount, riderId, carId);

    //Unlock, then signal that one more slot is full
    sem_post(&mutex);
    sem_post(&full);
}

/**
 * @brief The main thread which begins the simulation. After creating rider threads
 * which will run on their own, main sleeps for the duration of the simulation before
 * exiting; this terminates all other threads as well.
 * 
 * @param argc The number of program arguments
 * @param argv The pointer to the array of program arguments
 * @return int The exit code
 */
int main(int argc, char ** argv)
{
    //Read in number of cars and riders, also simulation runtime
    numCars = atoi(argv[1]);
    int numThreads = atoi(argv[2]);
    int runTime = atoi(argv[3]);

    //Compute number of digits in certain values (for clean looking output)
    int copy = numThreads;
    while (copy) {
        copy /= 10;
        numThreadsDigitCount++;
    }

    //Initialize semaphores
    sem_init(&mutex, 0, 1);
    sem_init(&empty, 0, 0);
    sem_init(&full, 0, numCars);

    //Create buffer of cars and initialize relevant values
    cars = (int *) malloc(numCars * sizeof(int));
    nextCarIn = INITIAL_VAL;
    nextCarOut = 0;
    for (int i = 0; i < numCars; i++) {
        cars[i] = i + 1;
    }

    //Create array of arguments for multithreading
    Param * params = (Param *) malloc(numThreads * sizeof(Param));
    for (int i = 0; i < numThreads; i++) {
        params[i].riderId = i + 1;
    }

    //Set up and execute multithreading
    pthread_t threadId[numThreads];
    pthread_attr_t attr; 
    pthread_attr_init(&attr);
    for (int i = 0; i < numThreads; i++) {
        pthread_create(&(threadId[i]), &attr, simulateRider, &(params[i]));
    }

    //Let main wait so rider simulation can occur
    sleep(runTime);

    /**
    //Free threading arguments and semaphores
    free(params);
    free(threadId);
    sem_destroy(&mutex);
    sem_destroy(&empty);
    sem_destroy(&full);
    */

    //Exit successfully
    return EXIT_SUCCESS;
}

//Confirmation that I'm downloading the most recent version of this file from remote school servers