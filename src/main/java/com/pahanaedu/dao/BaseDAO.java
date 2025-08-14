package com.pahanaedu.dao;

import java.io.*;
import java.util.ArrayList;
import java.util.List;

public abstract class BaseDAO<T> {
    protected String filePath;
    
    public BaseDAO(String filePath) {
        this.filePath = filePath;
        createFileIfNotExists();
    }
    
    private void createFileIfNotExists() {
        try {
            File file = new File(filePath);
            File parentDir = file.getParentFile();
            if (parentDir != null && !parentDir.exists()) {
                parentDir.mkdirs();
            }
            if (!file.exists()) {
                file.createNewFile();
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
    
    protected List<String> readAllLines() {
        List<String> lines = new ArrayList<>();
        try (BufferedReader reader = new BufferedReader(new FileReader(filePath))) {
            String line;
            while ((line = reader.readLine()) != null) {
                if (!line.trim().isEmpty()) {
                    lines.add(line);
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return lines;
    }
    
    protected void writeAllLines(List<String> lines) {
        try (PrintWriter writer = new PrintWriter(new FileWriter(filePath))) {
            for (String line : lines) {
                writer.println(line);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
    
    protected void appendLine(String line) {
        try (PrintWriter writer = new PrintWriter(new FileWriter(filePath, true))) {
            writer.println(line);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
    
    public abstract List<T> findAll();
    public abstract T findById(String id);
    public abstract boolean save(T entity);
    public abstract boolean update(T entity);
    public abstract boolean delete(String id);
}
