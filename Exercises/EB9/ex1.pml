#include "bw_sem.h"

byte sem = 0

proctype p(){
    do 
    :: x<200;
    x++
    od
}

proctype q(){
    do
    :: x>0;
    x--
    od
}

proctype r(){
    do
    :: x==200;
    x=0
    od
}

init{
    atomic {
        run p();
        run q();
        run r();
    }
}