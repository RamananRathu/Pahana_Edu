package com.pahanaedu.service;

import com.pahanaedu.dao.ItemDAO;
import com.pahanaedu.model.Item;
import java.util.List;

public class ItemService {
    private ItemDAO itemDAO;
    
    public ItemService() {
        this.itemDAO = new ItemDAO();
    }
    
    public List<Item> getAllItems() {
        return itemDAO.findAll();
    }
    
    public Item getItemById(int id) {
        return itemDAO.findById(id);
    }
    
    public Item getItemByCode(String itemCode) {
        return itemDAO.findByItemCode(itemCode);
    }
    
    public boolean createItem(Item item) {
        if (item == null || item.getItemCode() == null || item.getTitle() == null) {
            return false;
        }
        
        // Check if item code already exists
        if (itemDAO.findByItemCode(item.getItemCode()) != null) {
            return false;
        }
        
        return itemDAO.save(item);
    }
    
    public boolean updateItem(Item item) {
        if (item == null || item.getId() <= 0) {
            return false;
        }
        return itemDAO.update(item);
    }
    
    public boolean deleteItem(int id) {
        return itemDAO.delete(id);
    }
    
    public boolean isItemCodeExists(String itemCode) {
        return itemDAO.findByItemCode(itemCode) != null;
    }
    
    public boolean updateStock(int id, int newStock) {
        Item item = itemDAO.findById(id);
        if (item != null) {
            item.setStockQuantity(newStock);
            return itemDAO.update(item);
        }
        return false;
    }
    
    public List<Item> getLowStockItems() {
        return itemDAO.findLowStockItems();
    }
}
