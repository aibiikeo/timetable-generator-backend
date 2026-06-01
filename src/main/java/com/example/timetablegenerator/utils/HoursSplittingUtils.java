package com.example.timetablegenerator.utils;

import java.util.*;
import java.util.stream.Collectors;

public class HoursSplittingUtils {

    private static final List<Integer> REGULAR_HOURS = List.of(4, 3, 2);
    private static final List<Integer> ADVISOR_HOURS = List.of(1);

    public static List<String> generateSplittingOptionsForUI(int totalHours) {
        List<String> options = new ArrayList<>();
        if (totalHours == 1) {
            options.add("1");
        } else {
            List<List<Integer>> splittings = generateUniqueSplittings(totalHours, REGULAR_HOURS);
            for (List<Integer> splitting : splittings) {
                String option = splitting.stream()
                        .map(String::valueOf)
                        .collect(Collectors.joining("+"));
                options.add(option);
            }
        }
        options.add("manual");
        return options;
    }

    public static List<List<Integer>> generateUniqueSplittings(int totalHours, List<Integer> availableHours) {
        List<List<Integer>> result = new ArrayList<>();
        generateCombinations(totalHours, new ArrayList<>(), result, availableHours,
                availableHours.stream().max(Integer::compare).orElse(1));
        return result;
    }

    private static void generateCombinations(int remaining, List<Integer> current,
                                             List<List<Integer>> result,
                                             List<Integer> availableHours,
                                             int maxAllowed) {
        if (remaining == 0) {
            result.add(new ArrayList<>(current));
            return;
        }
        if (remaining < 0) return;

        for (int hours : availableHours) {
            if (hours <= maxAllowed && hours <= remaining) {
                current.add(hours);
                generateCombinations(remaining - hours, current, result, availableHours, hours);
                current.removeLast();
            }
        }
    }

    public static List<Integer> parseSplitting(String splitting, int totalHours) {
        if (splitting == null || splitting.isBlank() || "manual".equals(splitting)) {
            return generateDefaultSplitting(totalHours);
        }
        return Arrays.stream(splitting.split("\\+"))
                .map(String::trim)
                .map(Integer::parseInt)
                .collect(Collectors.toList());
    }

    public static List<Integer> generateDefaultSplitting(int totalHours) {
        if (totalHours == 1) {
            return List.of(1);
        }
        List<Integer> result = new ArrayList<>();
        int remaining = totalHours;
        while (remaining > 0) {
            if (remaining >= 4) {
                result.add(4);
                remaining -= 4;
            } else if (remaining >= 3) {
                result.add(3);
                remaining -= 3;
            } else {
                result.add(2);
                remaining -= 2;
            }
        }
        return result;
    }

    public static boolean isValidSplitting(String splitting, int totalHours) {
        try {
            List<Integer> hours = parseSplitting(splitting, totalHours);
            int sum = hours.stream().mapToInt(Integer::intValue).sum();
            if (sum != totalHours) return false;
            if (totalHours == 1) {
                return hours.size() == 1 && hours.getFirst() == 1;
            } else {
                return hours.stream().allMatch(h -> h == 2 || h == 3 || h == 4);
            }
        } catch (Exception e) {
            return false;
        }
    }
}
