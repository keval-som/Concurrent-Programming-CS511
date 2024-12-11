#include "bw_sem.h"

byte sem = 1;

proctype P() {
    do
    :: acquire(sem);
       release(sem)
    od
}

proctype Q() {
    do
    :: acquire(sem);
       release(sem)
    od
}

init {
    atomic {
        run P();
        run Q()
    }
}