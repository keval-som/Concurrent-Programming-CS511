class Barrier {
    private int c
    private final int B
    Barrier(int size){
        c=0
        this.B=size
    }
    synchronized void sync {
        if(c<B) {
            c++
            while(c<B) {
                wait()
            }
            notify()
        }
    }
}

final int N=3
final int B=3

Barrier b = new Barrier(B)
N.times {
    int id = it
    Thread.start {
            
        b.sync()
    }
}