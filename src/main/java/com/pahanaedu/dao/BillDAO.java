package com.pahanaedu.dao;

import com.pahanaedu.config.DatabaseConfig;
import com.pahanaedu.model.Bill;
import com.pahanaedu.model.BillItem;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BillDAO {
    
    public List<Bill> findAll() {
        List<Bill> bills = new ArrayList<>();
        String sql = "SELECT b.*, c.account_number, CONCAT(c.first_name, ' ', c.last_name) as customer_name " +
                    "FROM bills b " +
                    "JOIN customers c ON b.customer_id = c.id " +
                    "ORDER BY b.created_at DESC";
        
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Bill bill = mapResultSetToBill(rs);
                bill.setBillItems(getBillItems(bill.getId()));
                bills.add(bill);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bills;
    }
    
    public Bill findById(int id) {
        String sql = "SELECT b.*, c.account_number, CONCAT(c.first_name, ' ', c.last_name) as customer_name " +
                    "FROM bills b " +
                    "JOIN customers c ON b.customer_id = c.id " +
                    "WHERE b.id = ?";
        
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Bill bill = mapResultSetToBill(rs);
                    bill.setBillItems(getBillItems(bill.getId()));
                    return bill;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public Bill findByBillNumber(String billNumber) {
        String sql = "SELECT b.*, c.account_number, CONCAT(c.first_name, ' ', c.last_name) as customer_name " +
                    "FROM bills b " +
                    "JOIN customers c ON b.customer_id = c.id " +
                    "WHERE b.bill_number = ?";
        
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, billNumber);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Bill bill = mapResultSetToBill(rs);
                    bill.setBillItems(getBillItems(bill.getId()));
                    return bill;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public boolean save(Bill bill) {
        Connection conn = null;
        try {
            conn = DatabaseConfig.getConnection();
            conn.setAutoCommit(false);
            
            // Insert bill
            String billSql = "INSERT INTO bills (bill_number, customer_id, bill_date, due_date, " +
                           "subtotal, tax_rate, tax_amount, discount_amount, total_amount, " +
                           "paid_amount, balance_amount, status, payment_method, payment_date, " +
                           "notes, created_by) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            
            try (PreparedStatement billStmt = conn.prepareStatement(billSql, Statement.RETURN_GENERATED_KEYS)) {
                billStmt.setString(1, bill.getBillNumber());
                billStmt.setInt(2, bill.getCustomerId());
                billStmt.setTimestamp(3, bill.getBillDate());
                billStmt.setDate(4, bill.getDueDate());
                billStmt.setBigDecimal(5, bill.getSubtotal());
                billStmt.setBigDecimal(6, bill.getTaxRate());
                billStmt.setBigDecimal(7, bill.getTaxAmount());
                billStmt.setBigDecimal(8, bill.getDiscountAmount());
                billStmt.setBigDecimal(9, bill.getTotalAmount());
                billStmt.setBigDecimal(10, bill.getPaidAmount());
                billStmt.setBigDecimal(11, bill.getBalanceAmount());
                billStmt.setString(12, bill.getStatus());
                billStmt.setString(13, bill.getPaymentMethod());
                billStmt.setTimestamp(14, bill.getPaymentDate());
                billStmt.setString(15, bill.getNotes());
                billStmt.setInt(16, bill.getCreatedBy());
                
                int affectedRows = billStmt.executeUpdate();
                
                if (affectedRows > 0) {
                    try (ResultSet generatedKeys = billStmt.getGeneratedKeys()) {
                        if (generatedKeys.next()) {
                            bill.setId(generatedKeys.getInt(1));
                        }
                    }
                    
                    // Insert bill items
                    if (bill.getBillItems() != null && !bill.getBillItems().isEmpty()) {
                        String itemSql = "INSERT INTO bill_items (bill_id, item_id, description, quantity, unit_price, line_total) VALUES (?, ?, ?, ?, ?, ?)";
                        try (PreparedStatement itemStmt = conn.prepareStatement(itemSql)) {
                            for (BillItem item : bill.getBillItems()) {
                                itemStmt.setInt(1, bill.getId());
                                itemStmt.setObject(2, item.getItemId());
                                itemStmt.setString(3, item.getDescription());
                                itemStmt.setInt(4, item.getQuantity());
                                itemStmt.setBigDecimal(5, item.getUnitPrice());
                                itemStmt.setBigDecimal(6, item.getLineTotal());
                                itemStmt.addBatch();
                            }
                            itemStmt.executeBatch();
                        }
                    }
                    
                    conn.commit();
                    return true;
                }
            }
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
        return false;
    }
    
    public boolean update(Bill bill) {
        String sql = "UPDATE bills SET customer_id = ?, bill_date = ?, due_date = ?, " +
                    "subtotal = ?, tax_rate = ?, tax_amount = ?, discount_amount = ?, " +
                    "total_amount = ?, paid_amount = ?, balance_amount = ?, status = ?, " +
                    "payment_method = ?, payment_date = ?, notes = ? WHERE id = ?";
        
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, bill.getCustomerId());
            stmt.setTimestamp(2, bill.getBillDate());
            stmt.setDate(3, bill.getDueDate());
            stmt.setBigDecimal(4, bill.getSubtotal());
            stmt.setBigDecimal(5, bill.getTaxRate());
            stmt.setBigDecimal(6, bill.getTaxAmount());
            stmt.setBigDecimal(7, bill.getDiscountAmount());
            stmt.setBigDecimal(8, bill.getTotalAmount());
            stmt.setBigDecimal(9, bill.getPaidAmount());
            stmt.setBigDecimal(10, bill.getBalanceAmount());
            stmt.setString(11, bill.getStatus());
            stmt.setString(12, bill.getPaymentMethod());
            stmt.setTimestamp(13, bill.getPaymentDate());
            stmt.setString(14, bill.getNotes());
            stmt.setInt(15, bill.getId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean delete(int id) {
        String sql = "UPDATE bills SET status = 'cancelled' WHERE id = ?";
        
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public List<Bill> findByCustomerId(int customerId) {
        List<Bill> bills = new ArrayList<>();
        String sql = "SELECT b.*, c.account_number, CONCAT(c.first_name, ' ', c.last_name) as customer_name " +
                    "FROM bills b " +
                    "JOIN customers c ON b.customer_id = c.id " +
                    "WHERE b.customer_id = ? ORDER BY b.created_at DESC";
        
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, customerId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Bill bill = mapResultSetToBill(rs);
                    bill.setBillItems(getBillItems(bill.getId()));
                    bills.add(bill);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bills;
    }
    
    private List<BillItem> getBillItems(int billId) {
        List<BillItem> items = new ArrayList<>();
        String sql = "SELECT * FROM bill_items WHERE bill_id = ? ORDER BY id";
        
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, billId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    BillItem item = new BillItem();
                    item.setId(rs.getInt("id"));
                    item.setBillId(rs.getInt("bill_id"));
                    item.setItemId((Integer) rs.getObject("item_id"));
                    item.setDescription(rs.getString("description"));
                    item.setQuantity(rs.getInt("quantity"));
                    item.setUnitPrice(rs.getBigDecimal("unit_price"));
                    item.setLineTotal(rs.getBigDecimal("line_total"));
                    item.setCreatedAt(rs.getTimestamp("created_at"));
                    items.add(item);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return items;
    }
    
    private Bill mapResultSetToBill(ResultSet rs) throws SQLException {
        Bill bill = new Bill();
        bill.setId(rs.getInt("id"));
        bill.setBillNumber(rs.getString("bill_number"));
        bill.setCustomerId(rs.getInt("customer_id"));
        bill.setCustomerName(rs.getString("customer_name"));
        bill.setCustomerAccountNumber(rs.getString("account_number"));
        bill.setBillDate(rs.getTimestamp("bill_date"));
        bill.setDueDate(rs.getDate("due_date"));
        bill.setSubtotal(rs.getBigDecimal("subtotal"));
        bill.setTaxRate(rs.getBigDecimal("tax_rate"));
        bill.setTaxAmount(rs.getBigDecimal("tax_amount"));
        bill.setDiscountAmount(rs.getBigDecimal("discount_amount"));
        bill.setTotalAmount(rs.getBigDecimal("total_amount"));
        bill.setPaidAmount(rs.getBigDecimal("paid_amount"));
        bill.setBalanceAmount(rs.getBigDecimal("balance_amount"));
        bill.setStatus(rs.getString("status"));
        bill.setPaymentMethod(rs.getString("payment_method"));
        bill.setPaymentDate(rs.getTimestamp("payment_date"));
        bill.setNotes(rs.getString("notes"));
        bill.setCreatedAt(rs.getTimestamp("created_at"));
        bill.setUpdatedAt(rs.getTimestamp("updated_at"));
        bill.setCreatedBy(rs.getInt("created_by"));
        return bill;
    }
}
