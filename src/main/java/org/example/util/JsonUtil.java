package org.example.util;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;

public class JsonUtil {
    private static final ObjectMapper mapper = new ObjectMapper()
            .enable(SerializationFeature.INDENT_OUTPUT);

    public static String formatJson(String jsonString) {
        try {
            Object json = mapper.readValue(jsonString, Object.class);
            return mapper.writeValueAsString(json);
        } catch (JsonProcessingException e) {
            return jsonString; // Return original if invalid
        }
    }
}
