import java.util.concurrent.Semaphore
import java.util.Random

NUM_TRACKS = 2
NUM_TRAINS = 100

Semaphore permToLoad = new Semaphore(0)
Semaphore doneLoading = new Semaphore(0)
Semaphore[] trackMutex = new Semaphore[2]
2.times { trackMutex[it] = new Semaphore(1) }
Semaphore stationMutex = new Semaphore(2)

int[] trainsOnTrack = new int[2]
2.times { trainsOnTrack[it] = 0 }
int FreightAtStation = 0

// Passenger Train Thread
100.times {
    int dir = (new Random()).nextInt(2)
    Thread.start { // Passenger Train travelling in direction dir
        trackMutex[dir].acquire()
        if (trainsOnTrack[dir] == 0 && FreightAtStation == 0) {
            stationMutex.acquire()
            trainsOnTrack[dir]++
            trackMutex[dir].release()

            // Enter station
            println("Passenger Train travelling in direction $dir is at the station")
            Thread.sleep(1000) // Simulate time at the station

            // Leave station
            trackMutex[dir].acquire()
            trainsOnTrack[dir]--
            stationMutex.release()
            trackMutex[dir].release()
            println("Passenger Train travelling in direction $dir has left the station")
        } else {
            println("Passenger Train travelling in direction $dir didnt enter the station")
            trackMutex[dir].release()
        }
    }
}

// Freight Train Thread
100.times {
    int dir = (new Random()).nextInt(2)
    Thread.start { // Freight Train travelling in direction dir
        stationMutex.acquire(2)
        if (FreightAtStation == 0 && trainsOnTrack[dir] == 0) {
            trackMutex[dir].acquire()
            FreightAtStation++
            trainsOnTrack[dir]++

            trackMutex[dir].release()
            stationMutex.release(2)

            // Request loading
            permToLoad.release()
            println("Freight Train travelling in direction $dir is at the station and waiting to be loaded")
            doneLoading.acquire()

            // Leave station
            stationMutex.acquire(2)
            trackMutex[dir].acquire()
            FreightAtStation--
            trainsOnTrack[dir]--
            trackMutex[dir].release()
            stationMutex.release(2)
            println("Freight Train travelling in direction $dir has been loaded and left the station")
        } else {
            println("Freight Train travelling in direction $dir didnt enter the station")
            stationMutex.release(2)
        }
    }
}

// Loading Machine Thread
Thread.start {
    while (true) {
        permToLoad.acquire()
        // Load freight train
        println("Loading machine is loading a freight train")
        Thread.sleep(1000) // Simulate loading time
        doneLoading.release()
    }
}

return