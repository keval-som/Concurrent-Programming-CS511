import java.util.concurrent.Semaphore

// Declare semaphores
Semaphore boardingEastSemaphore = new Semaphore(0)
Semaphore unboardingEastSemaphore = new Semaphore(0)
Semaphore boardingWestSemaphore = new Semaphore(0)
Semaphore unboardingWestSemaphore = new Semaphore(0)
Semaphore mutex = new Semaphore(1)
Semaphore ferryFull = new Semaphore(0)

int N = 10 //Capacity
int passengersOnFerry = 0

Thread.start { // Ferry
    int coast=0
    while(true){
        println("Ferry is at coast $coast and waiting for passengers to board")
        for (int i = 0; i < N; i++){
            if(coast == 0){
                boardingEastSemaphore.release()
            }else{
            boardingWestSemaphore.release()
            }
        }
        ferryFull.acquire()

        coast = 1-coast
        Thread.sleep(1000)
        println("Ferry is at coast $coast and waiting for passengers to unboard")
        for (int i = 0; i < N; i++){
            if(coast == 1){
                unboardingEastSemaphore.release()
            }else{
                unboardingWestSemaphore.release()
            }
        }
        // while(passengersOnFerry > 0){
        //     Thread.sleep(1000)
        // }
        ferryFull.acquire()
    }
}

100.times{
    int id = it
    Thread.start{ // East Passenger
        boardingEastSemaphore.acquire()
        mutex.acquire()
        passengersOnFerry++
        println("East Passenger $id is boarding the ferry")
        if(passengersOnFerry == N){
            ferryFull.release()
        }
        mutex.release()
        //Travel
        unboardingEastSemaphore.acquire()
        mutex.acquire()
        passengersOnFerry--
        println("East Passenger $id is unboarding the ferry")
        if(passengersOnFerry == 0){
            ferryFull.release()
        }
        mutex.release()
    }
}

100.times{
    int id = it
    Thread.start{ // West Passenger
        boardingWestSemaphore.acquire()
        mutex.acquire()
        passengersOnFerry++
        println("West Passenger $id is boarding the ferry")
        if(passengersOnFerry == N){
            ferryFull.release()
        }
        mutex.release()
        //Travel
        unboardingWestSemaphore.acquire()
        mutex.acquire()
        passengersOnFerry--
        println("West Passenger $id is unboarding the ferry")
        if(passengersOnFerry == 0){
            ferryFull.release()
        }
        mutex.release()
    }
}

return