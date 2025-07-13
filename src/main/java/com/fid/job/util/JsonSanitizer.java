package com.fid.job.util;

import org.springframework.stereotype.Component;

@Component
public class JsonSanitizer {
    
    /**
     * Remove invalid surrogate characters from string
     * Invalid surrogates are in the range U+D800 to U+DFFF
     */
    public static String sanitize(String input) {
        if (input == null) {
            return null;
        }
        
        // Remove unpaired surrogates
        StringBuilder result = new StringBuilder();
        for (int i = 0; i < input.length(); i++) {
            char ch = input.charAt(i);
            
            // Check if this is a high surrogate
            if (Character.isHighSurrogate(ch)) {
                // Check if there's a valid low surrogate following
                if (i + 1 < input.length() && Character.isLowSurrogate(input.charAt(i + 1))) {
                    // Valid surrogate pair, keep both
                    result.append(ch);
                    result.append(input.charAt(i + 1));
                    i++; // Skip the low surrogate
                }
                // Otherwise skip this unpaired high surrogate
            } else if (!Character.isLowSurrogate(ch)) {
                // Not a surrogate, keep it
                result.append(ch);
            }
            // Skip unpaired low surrogates
        }
        
        return result.toString();
    }
    
    /**
     * Sanitize all string fields in an object
     */
    public static String sanitizeJsonString(String json) {
        if (json == null) {
            return null;
        }
        
        // Remove invalid control characters and unpaired surrogates
        return json.replaceAll("[\\x00-\\x1F\\x7F]", "") // Remove control characters
                   .replaceAll("[\\uD800-\\uDFFF](?![\\uDC00-\\uDFFF])|(?<![\\uD800-\\uDBFF])[\\uDC00-\\uDFFF]", ""); // Remove unpaired surrogates
    }
}