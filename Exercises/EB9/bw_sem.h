inline acquire(s) {
    atomic {
        s>0;
        s--
    }
}
inline release(s) {
    s++
}