import java.util.concurrent.Semaphore

// One-time use barrier
// Barrier size = N
// Total number of threads in the system = N
final int N = 3

// Declare semaphores and other variables here
Semaphore mutex = new Semaphore(1)
Semaphore barrier = new Semaphore(0)
int count = 0

N.times {
    int id = it
    Thread.start {
        // Complete barrier arrival protocol
        mutex.acquire()
        count++
        if (count == N) {
            barrier.release(N) // Release all threads
        }
        mutex.release()

        println id + " got to barrier. Waiting for the other threads"

        // Complete suspend at barrier
        barrier.acquire()

        println id + " went through."
    }
}