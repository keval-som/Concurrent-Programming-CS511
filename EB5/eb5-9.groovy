import java.util.concurrent.Semaphore;

Semaphore barrier = new Semaphore(0)
Semaphore mutex = new Semaphore(1)

final int N = 8
final int B = 5
int c = 0


N.times {
    int id = it
    Thread.start {
        // complete barrier arrival protocol
        mutex.acquire()
        c++
        if(c >= B) {
            barrier.release()
        } else {
        println id +" got to barrier . Waiting for the other threads "
        }
        mutex.release()
        barrier.acquire()
        // complete suspend at barrier
        barrier.release()
        println id +" went through ."
    }
}