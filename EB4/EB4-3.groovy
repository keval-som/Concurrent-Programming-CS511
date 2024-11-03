import java.util.concurrent.*;
Semaphore okA = new Semaphore(0);
Semaphore okB = new Semaphore(0);
Semaphore ok = new Semaphore(0);

Thread.start {
    print ( " R " ) 
    okA.release()
    ok.acquire()
    print ( " OK " ) 
}

Thread.start {
    okA.acquire()
    print ( " I " ) 
    okB.release()
    ok.acquire()
    print ( " OK " ) 
}

Thread.start {
    okB.acquire()
    print ( " O " ) 
    ok.release(2)
    print ( " OK " ) 
}