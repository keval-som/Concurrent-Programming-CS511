class Bar {
// your code here
    private int c

    Bar() {
        c = 0
        late = false
    }

    synchronized void jets() {
        while(c < 2 && !late) {
            wait()
        }
        if(!late) {
            c-=2
        }
    }
    synchronized void patriots() {
        c++
        if(c>1) {
        notify()
        }
    } 
    synchronized void itGotLate() {
        late = true
        notifyAll()
    }
}
Bar b = new Bar () ;
100. times {
    Thread . start { // jets
    b . jets () ;
    print("  jets  ")
    }
}

100. times {
    Thread . start { // patriots
        b . patriots () ;
        print("  patriots  ")
    }
}