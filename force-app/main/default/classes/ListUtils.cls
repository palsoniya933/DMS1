public class ListUtils {
    public static Boolean hasIntersectionIgnoreCase(List<String> sourceList, List<String> targetList){
        if(sourceList == null || targetList == null){
            return false;
        }
        
        Set<String> normalizedSourceSet = convertToNormalizedLowerCaseSet(sourceList);
        
        for(String targetItem : targetList){
            String normalizedItem = normalizeString(targetItem);
            if(!String.isEmpty(normalizedItem) && normalizedSourceSet.contains(normalizedItem)){
                return true;
            }
        }
        return false;
    }
    
    private static Set<String> convertToNormalizedLowerCaseSet(List<String> inputList){
        Set<String> normalizedSet = new Set<String>();
        for(String inputItem : inputList){
            String normalizedItem = normalizeString(inputItem);
            if(!String.isEmpty(normalizedItem)){
                normalizedSet.add(normalizedItem);
            }
        }
        return normalizedSet;
    }
    
    private static String normalizeString(String inputString){
        return inputString != null ? inputString.trim().toLowerCase() : '';
    }
}