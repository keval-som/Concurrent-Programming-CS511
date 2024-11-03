import java.util.concurrent.Semaphore
//Keval Sompura and Max tuscano
Semaphore gasUp = new Semaphore(6, true)
Semaphore gasStationAccess = new Semaphore(1)
Semaphore mutexC = new Semaphore(1)
Semaphore mutexT = new Semaphore(1)


final int NC = 100   // no of cars
final int NT = 10   // trucks
int truckCount = 0
int carCount = 0

NC.times {
    Thread.start {
        mutexC.acquire()
        carCount++
        print("car Entered ")
        if(carCount == 1) {
            print("car waiting for access ")
            gasStationAccess.acquire()
            print("Car acquired gas station access ")
        }
        gasUp.acquire()
        mutexC.release()
        
        print("Car is fueling up")
        Thread.sleep(5)

        mutexC.acquire()
        carCount--
        if(carCount == 0) {
            gasStationAccess.release()
            print("Car left gas station ")
        }
        gasUp.release()
        mutexC.release()
    }
}

NT.times {
    Thread.start {
        mutexT.acquire()
        truckCount++
        if(truckCount == 1) {
            print("Truck waiting gas station access ")
            gasStationAccess.acquire()
            print("Truck acquired gas station access ")
        }
        gasUp.acquire()
        mutexT.release()
        
        print("Truck is fueling up ")
        Thread.sleep(5)

        mutexT.acquire()
        truckCount--
        if(truckCount == 0) {
            gasStationAccess.release()
            print("truck released gas station access ")
        }
        gasUp.release()
        mutexT.release()
    }
}