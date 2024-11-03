import java.util.concurrent.locks.*;
class Grid {
    private int consumers
    private int producers
    private int N
    private Lock lock = new ReentrantLock()
    private Condition consume = lock.newCondition()
    private Condition produce = lock.newCondition()

    Grid(int N) {
        this.N = N
        consumers = 0
        producers = 0
    }

    void startConsuming () {
        lock.lock()
        try{
            while(producers < consumers) {
                consume.await()
            }
            consumers++
            println("Consuming Consumers = "+consumers)
            
        } finally {
            lock.unlock()
        }
    }

    void stopConsuming () {
        lock.lock()
        try {
            consumers--
            println("Stopped Consumimg Electricity = "+consumers)
            if(consumers == 0) {
                produce.signalAll()
            }
        } finally {
            lock.unlock()
        }
    }

    void startProducing () {
        lock.lock()
        try {
            while(producers == N) {
                produce.await()
            }
            producers++
            println("Producing Producers = "+producers)
            if(producers > consumers) {
                consume.signalAll()
                produce.signal()
            }
        } finally {
            lock.unlock()
        }
    }

    void stopProducing () {
        lock.lock()
        try{
            while(producers - 1 < consumers) {
                produce.await()
            }
            producers--
            println("Stopped Producing Electricity = "+producers)
        } finally {
            lock.unlock()
        }
    }

}

final int CP =100
Grid grid = new Grid(10)

CP . times {
    Thread . start {
        switch (( new Random ()). nextInt (2)) {
        case 0: grid . startConsuming ()
        grid . stopConsuming ()
        default : grid . startProducing ()
        grid . stopProducing ()
        }
    }
}