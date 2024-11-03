class Sequencer {
    int c = 0
    Sequencer() {
        c = 0
    }

    synchronized void first() {
        while(c != 0) {
            wait()
        }
        c = 1
        print("  first  ")
        notifyAll()
    }
    
    synchronized void second() {
        while(c != 1) {
            wait()
        }
        c = 2
        print("  second  ")
        notifyAll()
    }

    synchronized void third() {
        while(c != 2) {
            wait()
        }
        c = 0
        print("  third  ")
        notifyAll()
    }
}

final int N=20

Sequencer s = new Sequencer()

N.times {
    int id = it
    Thread.start {
        int c = id % 3
        if(c == 0) {
            print(" calling first ")
            s.first()
        } else if(c == 1) {
            print(" calling second ")
            s.second()
        } else {
            print(" calling third ")
            s.third()
        }
    }
}