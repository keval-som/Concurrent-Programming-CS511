import java.util.concurrent.*;
Semaphore okA = new Semaphore(0);


Thread.start {
    print "a"
    okA.release()
}

Thread.start {
    okA.acquire()
    print "b"
    okA.release(2)
}

Thread.start {
    okA.acquire(2)
    print "c"
}
