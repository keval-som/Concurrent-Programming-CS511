import java.util.concurrent.*;
Semaphore okA = new Semaphore(0);
int y = 0, z= 0;

Thread.start {
    int x;
    okA.release()
    x = y + z;
}

Thread.start {
    okA.acquire()
    y=1
    z=2
    okA.release()
}

