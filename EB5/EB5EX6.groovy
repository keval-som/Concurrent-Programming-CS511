import java.util.concurrent.Semaphore ;

Semaphore station0 = new Semaphore(1)
Semaphore station1 = new Semaphore(1)
Semaphore station2 = new Semaphore(1)
permToProcess = [new Semaphore(0) , new Semaphore(0) , new Semaphore(0)] // list of semaphores for machines
doneProcessing = [new Semaphore(0) , new Semaphore(0) , new Semaphore(0)] // list of semaphores for machines

100. times {
    Thread.start { // Car
        station0.acquire() // Go to station 0
        permToProcess[0].release()
        doneProcessing[0].acquire()

        station1.acquire() // Move on to station 1
        station0.release() // Leave station 0

        permToProcess[1].release()
        doneProcessing[1].acquire()

        station2.acquire() // Move on to station 2
        station1.release() // Leave station 1

        permToProcess[2].release()
        doneProcessing[2].acquire()
        station2.release() // Leave station 2
    }
}

3.times {
    int id = it ; // iteration variable
    Thread.start { // Machine at station id
        while ( true ) {
            permToProcess[id].acquire() // Wait for car to arrive
            doneProcessing[id].release() // Process car when it has arrived
        }
    }
}
return ;