#define N 2
#define B 2
byte mutexE = 1;
byte mutexL = 1;
byte barrier = 0;
byte barrier2 = 0;

int enter = 0;
int leaving = 0;

proctype P() {
    int i;
    for(i:1..10) {
        acquire(mutexE);
        enter++;
        if
         :: enter == B ->
                releaseN(barrier, B);
                enter = 0;
         :: else -> skip
        fi;
        release(mutexE) 

        acquire(barrier);
        
        atomic {
            int j;
            for(j:1.. N) {
                assert(c[_pid] == c[j - 1])
            }
        }
        release(mutexL);
        leaving++;
        release(mutexL); 
        acquire(barrier2);  
    }
}

init {

}