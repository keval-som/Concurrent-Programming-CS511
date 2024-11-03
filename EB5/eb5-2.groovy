import java.util.concurrent.Semaphore;

// Declare semaphores here
Semaphore feedingArea = new Semaphore(1)
Semaphore mutexC = new Semaphore(1)
Semaphore mutexD = new Semaphore(1)
int d=0
int c=0

20.times{ 
    Thread.start { // Cat
	// access feeding area
    mutexC.acquire()
	c++
	if (c==1) {
	    feedingArea.acquire()
	}
	mutexC.release()
       // eat
	// exit feeding area
	mutexC.acquire()
	c--
	if (c==0) {
	    feedingArea.release()
	}
	mutexC.release()
    }
}

20.times {
    Thread.start { // Dog
	// access feeding area
	mutexD.acquire()
	d++
	if (d==1) {
	    feedingArea.acquire()
	}
	mutexD.release()
       // eat
	// exit feeding area
	mutexD.acquire()
	d--
	if (d==0) {
	    feedingArea.release()
	}
	mutexD.release()
    }
}
