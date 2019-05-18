package java_basics.poison_challenge;


public class RatCalculator {

    /** Given number of glasses that could contain poison, returns minimum number of rats required */
    private int getMinTestRats(int glassCount) {
        int minRatCount = 1;
        int maxGlasses = 2;

        if (glassCount < 2) {
            System.out.println("Must provide at least 2 glasses");
            System.exit(1);
        }

        if (glassCount == 2) {
            return 1;
        }

        while (glassCount > maxGlasses) {
            minRatCount++;
            maxGlasses = getPower(2, minRatCount);
        }

        return minRatCount;
    }

    /** Given total number of rats at disposal, returns the maximum number of glasses that could be used */
    private int getMaxGlasses(int ratCount) {
        if (ratCount < 1) {
            System.out.println("Must provide at least 1 rat");
        }

        int maxGlasses = getPower(2, ratCount);

        return maxGlasses;
    }

    private int getPower(int base, int exponent) {
        return (int) Math.pow(base, exponent);
    }

    public static void main(String[] args) {
        // feel free to change these numbers and test
        int numberMilkGlasses = 8;
        int numberRats = 3;

        RatCalculator rc = new RatCalculator();

        String message1 = String.format("*%d* milk glasses requires a minimum of *%d* rats",
                numberMilkGlasses, rc.getMinTestRats(numberMilkGlasses));
        System.out.println(message1);

        String message2 = String.format("maximum glasses that can be used with *%d* rats is: *%d*",
                numberRats, rc.getMaxGlasses(numberRats));
        System.out.println(message2);
    }
}

