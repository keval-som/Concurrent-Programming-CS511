byte np = 0;
byte nq = 0;

active proctype p(){
    do 
    :: np = nq;
    np = np + 1;
    do
        :: nq == 0 || np < nq -> break;
        :: else
    od
    assert(nq == 0 || np < nq);
    np = 0;
    od
}

active proctype q(){
    do
    :: nq = np;
    nq = nq + 1;
    do
        :: np == 0 || nq < np -> break;
        :: else
    od
    assert(np == 0 || nq < np);
    nq = 0;
    od
}