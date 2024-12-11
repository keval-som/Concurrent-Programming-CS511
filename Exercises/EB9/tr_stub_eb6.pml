// Keval Sompura, Max Tuscano
#include "bw_sem.h"
#define PT 3 /* Number of Passenger Trains */
#define FT 1 /* Number of Freight Trains */

bool ntaken = false;
bool staken = false;
byte mutex = 1;    // binary semaphore
byte waitSet = 0;  // counting semaphore
byte waiting = 0;  // counter for number of trains waiting
byte tr_n = 0;     
byte tr_s = 0;     
byte tr_f = 0;

inline notifyAll(sem, count) {
  d_step {
    int j;
    for(j:1...count) {
      release(sem)
    }
  }
}

inline acquireNorthTrackP() {
  atomic {
    waitSet++;
    waiting++;
    if
    :: ntaken -> ntaken = false;
    :: else -> skip;
    fi
    tr_n++;
    ntaken = true;
    assert(tr_n == 1);
    waitSet--;
    waiting--;
  }
}


inline releaseNorthTrackP() {
  atomic {
    tr_n--;
    ntaken = false;
  }
}

inline acquireSouthTrackP() {
  atomic {
    if
    :: staken -> staken = false;
    :: else -> skip;
    fi
    tr_s++;
    staken = true;
    assert(tr_s == 1);
  }
}

inline releaseSouthTrackP() {
  atomic {
    staken = false;
    tr_s--;
  }
}

inline acquireTracksF() {
  atomic {
    if
    :: ntaken || staken ->
        ntaken = false;
        staken = false;
    :: else -> skip;
    fi
    tr_f++;
    ntaken = true;
    staken = true;    
    assert(tr_f == 1);
    assert(tr_s == 0 && tr_n == 0);
  }
}

inline releaseTracksF() {
  atomic {
    ntaken = false;
    staken = false;
    notifyAll(waitSet, waiting);
  }
}

proctype PassengerTrainNorth() { 
  acquireNorthTrackP();
  releaseNorthTrackP()
}

proctype PassengerTrainSouth() { 
  acquireSouthTrackP();
  releaseSouthTrackP()
}

proctype FreightTrain () { 
  acquireTracksF();
  releaseTracksF();
}

init {
  byte i;
  
  atomic {
    for (i:1.. PT) {
      /* spawn passenger trains */
      if /* randomly choose a direction */
	:: true -> run PassengerTrainNorth()
	:: true -> run PassengerTrainSouth()
      fi
    };
    for (i:0.. FT) { /* spawn freight trains */
      run FreightTrain()
    }
  }
}