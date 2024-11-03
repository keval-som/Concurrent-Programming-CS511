import java.util.concurrent.*;
Semaphore okA = new Semaphore(0);
Semaphore okB = new Semaphore(0);

Thread.start {
    print(" A ")
    okA.release()
    print(" B ")
    okB.acquire()
    print(" C ")
}

Thread.start {
    print(" E ")
    okA.acquire()
    print(" F ")
    okB.release()
    print(" G ")
}

