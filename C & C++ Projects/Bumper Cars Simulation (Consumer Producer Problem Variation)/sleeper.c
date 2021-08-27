#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <pthread.h>
#include <semaphore.h>

/** Source code provided by NCSU CSC Department */

/** Contains walkAroundTime() and rideTime() */
#include "sleeper.h"
/** Contains numThreadDigitCount as global variable to be externed into here */
#include "coordinator.h"

//Number for output format padding
extern int numThreadsDigitCount;

//Documented in header
void rideTime(int riderId, int carId)
{
    int seconds = ( random() % 5) + 1 ;
    printf("Rider %*d is now riding in car %d\n", numThreadsDigitCount, riderId, carId);
    sleep(seconds); 
}

//Documented in header
void walkAroundTime(int riderId)
{
    int seconds = (random() % 10) + 1 ;
    printf("Rider %*d is walking around the park for %d seconds\n", numThreadsDigitCount, riderId, seconds);
    sleep(seconds);
}

//Confirmation that I'm downloading the most recent version of this file from remote school servers
