import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.Executors;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Semaphore;
import java.util.concurrent.CountDownLatch;

public class Bakery implements Runnable {
    private static final int TOTAL_CUSTOMERS = 200;
    private static final int CAPACITY = 50;
    private static final int FULL_BREAD = 20;
    private Map<BreadType, Integer> availableBread;
    private ExecutorService executor;
    private float sales = 0;
    private CountDownLatch doneSignal = new CountDownLatch(TOTAL_CUSTOMERS);
    // TODO
    private Map<BreadType, Semaphore> shelfAccess;
    private Semaphore checkoutQ;
    private Semaphore salesSemaphore;
    private static final int CHECKOUT_COUNTERS = 4;
    /**
     * Remove a loaf from the available breads and restock if necessary
     */
    public void takeBread(BreadType bread, int itemSelectionTime) throws InterruptedException {
        shelfAccess.get(bread).acquire();
        int breadLeft = availableBread.get(bread);
        if (breadLeft > 0) {
            availableBread.put(bread, breadLeft - 1);
        } else {
            System.out.println("No " + bread.toString() + " bread left! Restocking...");
            // restock by preventing access to the bread stand for some time
            try {
                Thread.sleep(1000);
            } catch (InterruptedException ie) {
                ie.printStackTrace();
            }
            availableBread.put(bread, FULL_BREAD - 1);
        }
        Thread.sleep(itemSelectionTime);
        shelfAccess.get(bread).release();
    }

    /**
     * Add to the total sales
     */
    public void addSales(float value, int checkoutTime) throws InterruptedException {
        checkoutQ.acquire();
        salesSemaphore.acquire();
        sales += value;
        salesSemaphore.release();
        Thread.sleep(checkoutTime);
        checkoutQ.release();
    }

    /**
     * Run all customers in a fixed thread pool
     */
    public void run() {
        availableBread = new ConcurrentHashMap<BreadType, Integer>();
        availableBread.put(BreadType.RYE, FULL_BREAD);
        availableBread.put(BreadType.SOURDOUGH, FULL_BREAD);
        availableBread.put(BreadType.WONDER, FULL_BREAD);

        shelfAccess = new ConcurrentHashMap<BreadType, Semaphore>();
        shelfAccess.put(BreadType.RYE, new Semaphore(1));
        shelfAccess.put(BreadType.WONDER, new Semaphore(1));
        shelfAccess.put(BreadType.SOURDOUGH, new Semaphore(1));

        checkoutQ = new Semaphore(CHECKOUT_COUNTERS);
        salesSemaphore = new Semaphore(1);

        executor = Executors.newFixedThreadPool(CAPACITY);
        for(int i = 0; i < TOTAL_CUSTOMERS; i++) {
            executor.execute(new Customer(this, doneSignal));
        }
        try {
            doneSignal.await();
            System.out.println("Total sales = " + sales);
            executor.shutdown();
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        }
    }
}
