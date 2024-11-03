import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Random;
import java.util.concurrent.CountDownLatch;

public class Customer implements Runnable {
    private Bakery bakery;
    private Random rnd;
    private List<BreadType> shoppingList;
    private int shopTime;
    private int checkoutTime;
    private CountDownLatch doneSignal;

    /**
     * Initialize a customer object and randomize its shopping list
     */
    public Customer(Bakery bakery, CountDownLatch l) {
        // TODO
        this.bakery = bakery;
        this.doneSignal = l;
        rnd = new Random();
        shoppingList = new ArrayList<>();
        fillShoppingList();
    }

    /**
     * Run tasks for the customer
     */
    public void run() {
        // TODO
        System.out.println("Customer "+hashCode()+" entered the shop");
        shopTime = rnd.nextInt(1000);
        checkoutTime = rnd.nextInt(1000);
        for (BreadType bt : shoppingList) {
            try {
                bakery.takeBread(bt, shopTime / shoppingList.size());
                System.out.println("Customer "+hashCode()+" took item "+ bt + " from the shelf");
            } catch (InterruptedException e) {
                throw new RuntimeException(e);
            }
        }
        System.out.println("Customer "+hashCode()+" proceeding towards checkout");
        try {
            float cartValue = getItemsValue();
            bakery.addSales(cartValue, checkoutTime);
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        }
        System.out.println(toString());
        doneSignal.countDown();
    }

    /**
     * Return a string representation of the customer
     */
    public String toString() {
        return "Customer " + hashCode() + ": shoppingList=" + Arrays.toString(shoppingList.toArray()) + ", shopTime=" + shopTime + ", checkoutTime=" + checkoutTime;
    }

    /**
     * Add a bread item to the customer's shopping list
     */
    private boolean addItem(BreadType bread) {
        // do not allow more than 3 items, chooseItems() does not call more than 3 times
        if (shoppingList.size() >= 3) {
            return false;
        }
        shoppingList.add(bread);
        return true;
    }

    /**
     * Fill the customer's shopping list with 1 to 3 random breads
     */
    private void fillShoppingList() {
        int itemCnt = 1 + rnd.nextInt(3);
        while (itemCnt > 0) {
            addItem(BreadType.values()[rnd.nextInt(BreadType.values().length)]);
            itemCnt--;
        }
    }

    /**
     * Calculate the total value of the items in the customer's shopping list
     */
    private float getItemsValue() {
        float value = 0;
        for (BreadType bread : shoppingList) {
            value += bread.getPrice();
        }
        return value;
    }
}