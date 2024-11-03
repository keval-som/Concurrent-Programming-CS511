import java.util.concurrent.*;
Semaphore okA = new Semaphore(0);
Semaphore okB = new Semaphore(0);

Thread.start {
    okA.acquire()
    print(" A ")
    print(" S ")
    okB.release()
}

Thread.start {
    print(" L ")
    okA.release()
    okB.acquire()
    print(" E ")
    print(" R ")
}

