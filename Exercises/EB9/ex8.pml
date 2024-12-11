byte turn = 0;
bool flags[3];

proctype p(){
    byte myId = _pid-1;
    byte left = (myId + 2)%3;
    byte right = (myId + 1)%3;
    do 
    :: flags[myId] = true;
    do
        :: flags[left] || flags[right] -> if 
            :: turn == left ->
                flags[myId] = false;
                do
                    :: turn == myId -> break;
                    :: else -> skip;
                od;
                flags[myId] = true;
            :: else -> break;
        fi;
    od;
    progress1:
        turn = right;
        flags[myId] = false;
    od; 
}

init {
    turn = 0;
    byte i;
    for ( i : 0..2){
        flags[i] = false;
    }
    atomic {
        run p();
        run p();
        run p();
    }
}
