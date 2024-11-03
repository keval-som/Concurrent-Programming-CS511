import java.util.concurrent.locks.*

class TrainStation {

    final Lock lock = new ReentrantLock();
    final Condition northTrackP = lock.newCondition();
    boolean northTrack = false;
    final Condition southTrackP = lock.newCondition();
    boolean southTrack = false;
    final Condition tracksF = lock.newCondition();
    boolean tracks = false;

    void acquireNorthTrackP() {
        lock.lock();
        while(tracks || northTrack) {
            northTrackP.await();
        }
        try {
            northTrack = true;

            // print("north track acquired by " + Thread.currentThread().getId());
        } finally {
            lock.unlock();
        }
    }

    void releaseNorthTrackP() {
        lock.lock();
        try{
            northTrack = false;
            northTrackP.signalAll();
            // print("north track released by " + Thread.currentThread().getId());
        } finally {
            lock.unlock();
        }
    }

    void acquireSouthTrackP() {
        lock.lock();
        while(tracks && southTrack) {
            southTrackP.await();
        }
        try {
            southTrack = true;
            // print("south track acquired by " + Thread.currentThread().getId());
        } finally {
            lock.unlock();
        }
    }

    void releaseSouthTrackP() {
        lock.lock();
        try {
            southTrack = false;
            southTrackP.signalAll();
            // print("south track released by " + Thread.currentThread().getId());
        } finally {
            lock.unlock();
        }
    }

    void acquireTracksF() {
        lock.lock();
        while(northTrack || southTrack) {
            northTrackP.await();
            southTrackP.await();
        }
        try{
            tracks=true
            // print("tracks acquired by freight " + Thread.currentThread().getId());
        } finally {
            lock.unlock();
        }
    }

    void releaseTracksF() {
        lock.lock();
        try {
            tracks = false;
            northTrackP.signalAll();
            southTrackP.signalAll();
            // print("tracks released by freight " + Thread.currentThread().getId());
        } finally {
            lock.unlock();
        }
    }
}

TrainStation s = new TrainStation ();
100.times {
    Thread . start { // Passenger Train going North
        s. acquireNorthTrackP ();
        print " NPT "+ Thread . currentThread (). getId ();
        s. releaseNorthTrackP ();   
    }
}
100.times {
    Thread . start { // Passenger Train going South
        s. acquireSouthTrackP ();
        print " SPT "+ Thread . currentThread (). getId ();
        s. releaseSouthTrackP ()
    }
}
10.times {
    Thread . start { // Freight Train
        s. acquireTracksF ();
        print "FT "+ Thread . currentThread (). getId ();
        s. releaseTracksF ();
    }
}