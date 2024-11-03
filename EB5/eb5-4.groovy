import java.util.concurrent.Semaphore

Semaphore boat = new Semaphore(1)
Semaphore eastCoast = new Semaphore(0)
Semaphore westCoast = new Semaphore(0)
Semaphore boatFull = new Semaphore(0)



Thread.start {
    int coast = 0   // 0 = east, 1 = west
    while (true) {  
        if(coast == 0) {
            boat.acquire()
            {
                eastCoast.release()
            }
            boat.release()
        }

        coast = 1 - coast
    }
}

100.times {
    Thread.start {  //east coast
        eastCoast.acquire()
        boatFull.acquire()
        
    }
}


100.times {
    Thread.start {  //west coast
       
    }
}