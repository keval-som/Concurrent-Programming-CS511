import java . util . concurrent . Semaphore ;

// Declare semaphores here
Semaphore feedingArea = new Semaphore(1) ;
Semaphore mutexC = new Semaphore(1) ;
Semaphore mutexD = new Semaphore(1) ;
int catCount = 0 ;
int dogCount = 0 ;

20.times{
    Thread.start{ // Cat
        // access feeding area
        mutexC.acquire() ;
            catCount++ ;
            if(catCount == 1){
                feedingArea.acquire() ;
            }
        mutexC.release() ;
        // eat
        println("Cat is eating")
        // exit feeding area
        mutexC.acquire() ;
            catCount-- ;
            if(catCount == 0){
                feedingArea.release() ;
            }
        mutexC.release() ;
    }
}

20.times{
    Thread.start{ // Dog
        // access feeding area
        mutexD.acquire() ;
            dogCount++ ;   
            if(dogCount == 1){
                feedingArea.acquire() ;
            }
        mutexD.release() ;
        // eat
        println("Dog is eating")
        mutexD.acquire() ;
            dogCount-- ;
            if(dogCount == 0){
                feedingArea.release() ;
            }
        mutexD.release() ;
        // exit feeding area
    }
}