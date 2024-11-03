import java.util.concurrent.locks.*
class Pizza {

    private int smallPizzas
    private int largePizzas
    private Lock lock = new ReentrantLock()
    private Condition smallPizza = lock.newCondition()
    private Condition largePizza = lock.newCondition()

    Pizza() {
        smallPizzas = 0
        largePizzas = 0
    }

    void purchaseSmallPizza() {
        lock.lock()
        try{
            while(smallPizzas == 0) {
                smallPizza.await()
            }
            smallPizzas--
            print("Small pizza purchased = "+smallPizzas)
        } finally {
            lock.unlock()
        }
    }

    void purchaseLargePizza() {
        lock.lock()
        boolean k = true
        try {
            while(largePizzas == 0) {
                if(smallPizzas >= 2) {
                    purchaseSmallPizza()
                    purchaseSmallPizza()
                    k = false
                } else {
                    largePizza.await()
                }
            }
            if(k) {
                largePizzas--
                print("Large pizza purchased = "+largePizzas)
            }
        } finally {
            lock.unlock()
        }
    }

    void bakeSmallPizza() {
        lock.lock()
        try {
            smallPizzas++
            smallPizza.signal()
            print("Small pizza baked = "+smallPizzas)
        } finally {
            lock.unlock()
        }
    }

    void bakeLargePizza() {
        lock.lock()
        try {
            largePizzas++
            largePizza.signal()
            print("Large pizza baked = "+largePizzas)
        } finally {
            lock.unlock()
        }
    }
}

final int N=10
final int B=10

Pizza p = new Pizza()

N.times {
    Thread.start {
        int i = new Random().nextInt(2)
        if(i == 0) {
            p.purchaseSmallPizza()
        } else {
            p.purchaseLargePizza()
        }
    }
}

B.times {
    Thread.start {
        int i = new Random().nextInt(2)
        if(i == 0) {
            p.bakeSmallPizza()
        } else {
            p.bakeLargePizza()
        }
    }
}