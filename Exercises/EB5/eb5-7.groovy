import java.util.concurrent.Semaphore;

Semaphore mutex = new Semaphore (1);

noOfCarsCrossing = [0 ,0]
r = new Random ()

100.times {
    int myEndPoint = r.nextInt(2)
    Thread.start {
        mutex.acquire()
        noOfCarsCrossing[myEndPoint]++
        mutex.release()
        if()
    }
}