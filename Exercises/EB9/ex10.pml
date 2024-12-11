#include "bw_sem.h"

byte ticket = 0;
byte mutex = 1;
byte p = 0;
byte j = 0;

active [5] proctype Jets() {
    acquire(mutex);
    acquire(ticket);
    acquire(ticket);
    j++;
    release(mutex);
    assert(2*j <= p);
}

active [20] proctype Patriots() {
    p++;    
release(ticket);
    assert(2*j <= p);
}

