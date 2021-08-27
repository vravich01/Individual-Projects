#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <pthread.h>
#include <semaphore.h>

/** Contains walkAroundTime() and rideTime() */
#include "sleeper.h"
/** Contains simulateRider */
#include "rider.h"
/** Contains Param struct, getInLine(), and returnCar() */
#include "coordinator.h"

//Documented in header
void * simulateRider(void * param)
{
    Param * paramptr = (Param *) param;
    int riderId = paramptr->riderId;

    while (1) {
        walkAroundTime(riderId);
        int carId = getInLine(riderId);
        rideTime(riderId, carId);
        returnCar(riderId, carId);
    }

    pthread_exit(NULL);
}

//Confirmation that I'm downloading the most recent version of this file from remote school servers