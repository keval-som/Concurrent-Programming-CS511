import java.util.concurrent.Semaphore;
Semaphore jets = new Semaphore(0)
Semaphore patriots = new Semaphore(2)
20.times{
    Thread.start {
        print("patriots ")
        jets.release()
    }
}

20.times{
    Thread.start {
        if(itGotLate) {
            jets.release(2)
        }
        jets.acquire(2)
        print("jets ")
    }
}