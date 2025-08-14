package com.pahanaedu.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class BillItem {
    private int id;
    private int billId;
    private Integer itemId;
    private String description;
    private int quantity;
    private BigDecimal unitPrice;
    private BigDecimal lineTotal;
    private Timestamp createdAt;
    
    public BillItem() {
        this.quantity = 1;
        this.unitPrice = BigDecimal.ZERO;
        this.lineTotal = BigDecimal.ZERO;
    }
    
    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public int getBillId() { return billId; }
    public void setBillId(int billId) { this.billId = billId; }
    
    public Integer getItemId() { return itemId; }
    public void setItemId(Integer itemId) { this.itemId = itemId; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { 
        this.quantity = quantity;
        calculateLineTotal();
    }
    
    public BigDecimal getUnitPrice() { return unitPrice; }
    public void setUnitPrice(BigDecimal unitPrice) { 
        this.unitPrice = unitPrice;
        calculateLineTotal();
    }
    
    public BigDecimal getLineTotal() { return lineTotal; }
    public void setLineTotal(BigDecimal lineTotal) { this.lineTotal = lineTotal; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    
    private void calculateLineTotal() {
        if (unitPrice != null) {
            this.lineTotal = unitPrice.multiply(new BigDecimal(quantity));
        }
    }
}
