bool flag [2];
bool turn;
byte critical = 0;

active [2] proctype user () {
    turn = _pid;
    flag [_pid] = true;

    do
    :: (flag [1 - _pid] == false || turn == 1 - _pid) -> break
    :: else -> skip
    od;
    // critical section
    critical++;
    assert (critical == 1);
    critical--;
    flag [_pid] = false;
}
