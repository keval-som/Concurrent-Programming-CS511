import java.util.concurrent.Semaphore;

final int MAX_WEIGHTS = 10;
final int GYM_CAP = 50;

Semaphore mutex = new Semaphore(1)
Semaphore gymAccess = new Semaphore(GYM_CAP)

def make_routine ( int no_exercises, int MAX_WEIGHTS) { // returns a random routine
    Random rand = new Random ();
    int size = rand . nextInt ( no_exercises );
    def routine = [];
        size . times {
        routine . add ( new Tuple ( rand . nextInt (4) , rand . nextInt (MAX_WEIGHTS)));
    }
return routine ;
}

100. times {
    int id = it;

    Thread . start { // Client
        gymAccess.acquire()
        def routine = make_routine (20, MAX_WEIGHTS) ; // random routine of 20 exercises
        print(routine)
        // enter gym

        routine . size (). times {
        // complete exercise on machine
        println " $id is performing :"+ routine [ it ][0] + " --"+ routine [ it ][1] ;
        }
        gymAccess.release()
    }
}
