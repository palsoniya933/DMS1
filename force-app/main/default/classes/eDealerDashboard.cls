public class eDealerDashboard {
	@AuraEnabled
    public static List<Map<String, String>> getFrequency(){
        String userLanguage = UserInfo.getLanguage();

        Map<String, Object> frequencyTranslations = EDealerMetadataUtility.frequencyTranslations;
        String defaultLanguage = 'en_US';

        List<Map<String, String>> options = new List<Map<String, String>>();

        for (String label : frequencyTranslations.keySet()) {
            Object value = frequencyTranslations.get(label);

            Map<String, String> translationsByLanguage = new Map<String, String>();

            if (value instanceof List<Object>) {
                for (Object item : (List<Object>)value) {
                    if (item instanceof Map<String, Object>) {
                        Map<String, Object> objMap = (Map<String, Object>)item;
                        for (String key : objMap.keySet()) {
                            translationsByLanguage.put(key, (String)objMap.get(key));
                        }
                    }
                }
            } else if (value instanceof Map<String, Object>) {
                Map<String, Object> objMap = (Map<String, Object>)value;
                for (String key : objMap.keySet()) {
                    translationsByLanguage.put(key, (String)objMap.get(key));
                }
            }

            String translatedValue = translationsByLanguage.get(userLanguage);
            if (translatedValue == null) {
                translatedValue = translationsByLanguage.get(defaultLanguage); 
            }

            options.add(new Map<String, String>{
                'label' => label,
                'value' => translatedValue
            });
        }

        return options;
    } 
}