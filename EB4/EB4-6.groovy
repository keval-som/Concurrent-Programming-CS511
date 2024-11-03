import java.util.concurrent.*;
Semaphore okA = new Semaphore(3);
Semaphore okB = new Semaphore(0);

Thread.start {
    while(true) {
        okA.acquire()
        print "a"
        okB.release()
    }
}

Thread.start {
    while(true) {
        okB.acquire(3)
        print "b"
        okA.release(3)
    }
}

Thread.start {
    while(true) {
        okB.acquire(3)
        print "c"
        okA.release(3)
    }
}
