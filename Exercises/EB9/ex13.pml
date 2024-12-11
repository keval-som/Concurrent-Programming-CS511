#define N 3 /* Number of Washing Machines */
#define C 10 /* Number of Cars */
#include "bw_sem.h"

byte permToProcess[N];
byte doneProcessing[N];
byte station0 = 1;
byte station1 = 1;
byte station2 = 1;

proctype Car() {
    /* complete */
}

proctype Machine(int i) {
    /* complete */
}

init {
    byte i;

    for (i : 0..(N-1)) {
        permToProcess[i] = 0;
        doneProcessing[i] = 0;
    }

    atomic {
        for (i : 1..(C)) {
            run Car();
        }
        for (i : 0..(N-1)) {
            run Machine(i);
        }
    }
}
