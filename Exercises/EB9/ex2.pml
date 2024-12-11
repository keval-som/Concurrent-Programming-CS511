byte turn = 1

proctype p(){
    do 
    :: do
        :: turn == 1 -> break;
        :: else
    od
    printf("p went in\n");
    turn = 2
    od 
}

proctype q(){
    do
    :: do
        :: turn == 2 -> break;
        :: else
    od
    printf("q went in\n");
    turn = 1
    od
}

init {
    atomic {
        run p();
        run q();
    }
}