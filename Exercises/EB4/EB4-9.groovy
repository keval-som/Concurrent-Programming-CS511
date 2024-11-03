import java.util.concurrent.*;
int n2 =0
int n =50
Semaphore mutex = new Semaphore(1);
Semaphore mutex2 = new Semaphore(0);
P = Thread . start {
    while ( n > 0) {
        mutex2.acquire()
        n = n - 1
        mutex.release()
    }
}
Thread . start {
    while ( true ) {
        mutex.acquire()
        n2 = n2 + 2*n + 1
        mutex2.release()
    }
}
P . join ()
print ( n2 )