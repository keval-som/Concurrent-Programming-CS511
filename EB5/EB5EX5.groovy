import java.util.concurrent.Semaphore
import java.util.Random

MAX_WEIGHTS = 10
GYM_CAP = 50

Semaphore gymCapacity = new Semaphore(GYM_CAP)
Semaphore[] apparatusMutex = new Semaphore[4]
4.times { apparatusMutex[it] = new Semaphore(1) }
Semaphore availableWeights = new Semaphore(MAX_WEIGHTS)


def make_routine(int no_exercises){
    Random rand = new Random()
    int size = rand.nextInt(no_exercises) + 1
    def routine = []
    size.times {
        routine.add(new Tuple(rand.nextInt(4), rand.nextInt(MAX_WEIGHTS) + 1))
    }
    return routine
}

100.times {
    int id = it
    Thread.start { // Client
        def routine = make_routine(20) // random routine of up to 20 exercises

        // Enter gym
        gymCapacity.acquire()

        routine.size().times { i ->
            def exercise = routine[i]
            int apparatus = exercise[0]
            int weightsNeeded = exercise[1]

            // Acquire weights
            availableWeights.acquire(weightsNeeded)
            println("Client $id acquired $weightsNeeded weights for apparatus $apparatus")

            // Use apparatus
            apparatusMutex[apparatus].acquire()
            println("Client $id is performing exercise on apparatus $apparatus with $weightsNeeded weights")
            Thread.sleep(1000) // Simulate exercise time
            apparatusMutex[apparatus].release()

            // Release weights
            println("Client $id released $weightsNeeded weights from apparatus $apparatus")
            availableWeights.release(weightsNeeded)
        }
        // Leave gym
        gymCapacity.release()
    }
}

return