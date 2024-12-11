#include "bw_sem.h"
#define NP 6
#define NJ 3

int lock = 1;
int delta = 0;
int wait = 0;

/* ghost variables (for assertions) */
int p = 0;
int j = 0;

inline enter_patriot() {
  acquire(lock);
  delta++;
  release(wait);
  p++;
  release(lock)
}

inline enter_jets() {
  acquire(lock);
  do
    :: delta<2 ->
       release(lock)
       acquire(wait)
       acquire(lock)
    :: else -> break
  od;
  delta=delta-2;
  j++;
  release(lock)  
}

proctype Patriots() {
  enter_patriot();
  assert (2*j<=p)
}

proctype Jets() {
  enter_jets()
  assert (2*j<=p)
}

init {
  byte i;
  atomic {  
    for (i: 1 .. NP) {
      run Patriots();
    };
    for (i: 1 .. NJ) {
      run Jets();
    }
  }
    
}

