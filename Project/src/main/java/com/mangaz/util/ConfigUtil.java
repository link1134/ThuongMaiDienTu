package com.mangaz.util;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public final class ConfigUtil {
    private ConfigUtil() {}

    public static Properties load(String name) {
        Properties p = new Properties();
        String envPrefix = name.toUpperCase().replace('.', '_').replace('-', '_');
        try (InputStream in = ConfigUtil.class.getClassLoader().getResourceAsStream(name)) {
            if (in != null) p.load(in);
        } catch (IOException e) {
            throw new IllegalStateException("Cannot load config: " + name, e);
        }
        return p;
    }
}
