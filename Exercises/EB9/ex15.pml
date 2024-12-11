#define acquire 0
#define release 1

chan sema = [0] of { bit }; /* synchronous channel */

proctype semaphore() {
    byte count = 1;
    do
    :: (count == 1) -> sema ! acquire; count = 0
    :: (count == 0) -> sema ? release; count = 1
    od
}
proctype user() {
    do
    :: sema ? acquire
        /* crit. sect */
        sema ! release
        /* non-crit. sect. */
    od
}

init {
    run semaphore();
    run user();
    run user();
}