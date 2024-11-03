import java.io.*;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.stream.Collectors;

public class TextSwap {
    // Name: Keval Ajay Sompura

    private static String readFile(String filename, int chunkSize) throws Exception {
        String line;
        StringBuilder buffer = new StringBuilder();
        File file = new File(filename);
	// The "-1" below is because of this:
	// https://stackoverflow.com/questions/729692/why-should-text-files-end-with-a-newline
	// if ((file.length()-1) % chunkSize!=0)
	//     { throw new Exception("File size not multiple of chunk size"); };
        BufferedReader br = new BufferedReader(new FileReader(file));
        while ((line = br.readLine()) != null){
            buffer.append(line);
        }
        br.close();
        return buffer.toString();
    }

    private static Interval[] getIntervals(int numChunks, int chunkSize) {
        // TODO: Implement me!
        Interval[] intervalArr = new Interval[numChunks];
        int lowerBound = 0;
        int upperBound = chunkSize-1;
        for (int i = 0; i < numChunks; i++) {
            Interval interval = new Interval(lowerBound, upperBound);
            intervalArr[i] = interval;
            lowerBound = upperBound + 1;
            upperBound += chunkSize;
        }
        return intervalArr;
    }

    private static List<Character> getLabels(int numChunks) {
        Scanner scanner = new Scanner(System.in);
        List<Character> labels = new ArrayList<Character>();
        int endChar = numChunks == 0 ? 'a' : 'a' + numChunks - 1;
        System.out.printf("Input %d character(s) (\'%c\' - \'%c\') for the pattern.\n", numChunks, 'a', endChar);
        for (int i = 0; i < numChunks; i++) {
            labels.add(scanner.next().charAt(0));
        }
        scanner.close();
        // System.out.println(labels);
        return labels;
    }

    private static char[] runSwapper(String content, int chunkSize, int numChunks) {
        List<Character> labels = getLabels(numChunks);
        Interval[] intervals = getIntervals(numChunks, chunkSize);
//        content = content.trim();
        char[] buffer = new char[content.length()];
        // TODO: Order the intervals properly, then run the Swapper instances.
        LinkedHashMap<Character, Integer> labelRank = new LinkedHashMap<Character, Integer>();
        labelRank = rankLabels(labels, labelRank);
        int offset = -chunkSize;
        List<Thread> threadList = new ArrayList<>();
        for (Integer i : labelRank.values()) {
            offset += chunkSize;
            Swapper swapper = new Swapper(intervals[i], content, buffer, offset);
            Thread thread = new Thread(swapper);
            threadList.add(thread);
            thread.start();
        }
        for (Thread thread: threadList) {
            try {
                thread.join();
            } catch (Exception e) {
                System.out.println(e.getMessage());
            }
        }
        return buffer;
    }

    private static void writeToFile(String contents, int chunkSize, int numChunks) throws Exception {
        if(numChunks > 26) {
            System.out.println("Chunk size too small");
            throw new Exception("Chunk size too small");
        }
        if(contents.length() % chunkSize != 0) {
            System.out.println("File size must be a multiple of the chunk size");
            throw new Exception("File size must be a multiple of the chunk size");
        }
        char[] buff = runSwapper(contents, chunkSize, contents.length() / chunkSize);
        PrintWriter writer = new PrintWriter("output.txt", "UTF-8");
        writer.print(buff);
        writer.close();
    }

     public static void main(String[] args) {
        if (args.length != 2) {
            System.out.println("Usage: java TextSwap <chunk size> <filename>");
            return;
        }
        String contents = "";
        int chunkSize = Integer.parseInt(args[0]);
        try {
            contents = readFile(args[1],chunkSize);
            writeToFile(contents, chunkSize, contents.length() / chunkSize);
        } catch (Exception e) {
            System.out.println("Error with IO.");
            return;
        }
    }

    public static LinkedHashMap<Character, Integer> rankLabels(List<Character> labels, LinkedHashMap<Character, Integer> labelRank) {
        labels.forEach(character -> labelRank.put(character, 0));
        List<Character> labelsDupe = new ArrayList<>(labels);
        Collections.sort(labelsDupe);
        for (int i = 0; i < labelsDupe.size(); i++) {
            labelRank.put(labelsDupe.get(i), i);
        }
        return labelRank;
    }
}
