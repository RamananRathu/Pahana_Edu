package com.pahanaedu.dao;

import com.pahanaedu.config.DatabaseConfig;
import com.pahanaedu.model.Customer;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CustomerDAO {
    
    public List<Customer> findAll() {
        List<Customer> customers = new ArrayList<>();
        String sql = "SELECT * FROM customers WHERE status = 'active' ORDER BY created_at DESC";
        
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                customers.add(mapResultSetToCustomer(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return customers;
    }
    
    public Customer findById(int id) {
        String sql = "SELECT * FROM customers WHERE id = ?";
        
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToCustomer(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public Customer findByAccountNumber(String accountNumber) {
        String sql = "SELECT * FROM customers WHERE account_number = ?";
        
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, accountNumber);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToCustomer(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public boolean save(Customer customer) {
        String sql = "INSERT INTO customers (account_number, first_name, last_name, email, phone, " +
                    "address_line1, address_line2, city, state, postal_code, country, date_of_birth, " +
                    "gender, units_consumed, credit_limit, status, created_by) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setString(1, customer.getAccountNumber());
            stmt.setString(2, customer.getFirstName());
            stmt.setString(3, customer.getLastName());
            stmt.setString(4, customer.getEmail());
            stmt.setString(5, customer.getPhone());
            stmt.setString(6, customer.getAddressLine1());
            stmt.setString(7, customer.getAddressLine2());
            stmt.setString(8, customer.getCity());
            stmt.setString(9, customer.getState());
            stmt.setString(10, customer.getPostalCode());
            stmt.setString(11, customer.getCountry());
            stmt.setDate(12, customer.getDateOfBirth());
            stmt.setString(13, customer.getGender());
            stmt.setInt(14, customer.getUnitsConsumed());
            stmt.setBigDecimal(15, customer.getCreditLimit());
            stmt.setString(16, customer.getStatus());
            stmt.setInt(17, customer.getCreatedBy());
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        customer.setId(generatedKeys.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean update(Customer customer) {
        String sql = "UPDATE customers SET first_name = ?, last_name = ?, email = ?, phone = ?, " +
                    "address_line1 = ?, address_line2 = ?, city = ?, state = ?, postal_code = ?, " +
                    "country = ?, date_of_birth = ?, gender = ?, units_consumed = ?, credit_limit = ?, " +
                    "status = ? WHERE id = ?";
        
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, customer.getFirstName());
            stmt.setString(2, customer.getLastName());
            stmt.setString(3, customer.getEmail());
            stmt.setString(4, customer.getPhone());
            stmt.setString(5, customer.getAddressLine1());
            stmt.setString(6, customer.getAddressLine2());
            stmt.setString(7, customer.getCity());
            stmt.setString(8, customer.getState());
            stmt.setString(9, customer.getPostalCode());
            stmt.setString(10, customer.getCountry());
            stmt.setDate(11, customer.getDateOfBirth());
            stmt.setString(12, customer.getGender());
            stmt.setInt(13, customer.getUnitsConsumed());
            stmt.setBigDecimal(14, customer.getCreditLimit());
            stmt.setString(15, customer.getStatus());
            stmt.setInt(16, customer.getId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean delete(int id) {
        String sql = "UPDATE customers SET status = 'inactive' WHERE id = ?";
        
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public List<Customer> searchCustomers(String searchTerm) {
        List<Customer> customers = new ArrayList<>();
        String sql = "SELECT * FROM customers WHERE status = 'active' AND " +
                    "(account_number LIKE ? OR first_name LIKE ? OR last_name LIKE ? OR email LIKE ?) " +
                    "ORDER BY created_at DESC";
        
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + searchTerm + "%";
            stmt.setString(1, searchPattern);
            stmt.setString(2, searchPattern);
            stmt.setString(3, searchPattern);
            stmt.setString(4, searchPattern);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    customers.add(mapResultSetToCustomer(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return customers;
    }
    
    private Customer mapResultSetToCustomer(ResultSet rs) throws SQLException {
        Customer customer = new Customer();
        customer.setId(rs.getInt("id"));
        customer.setAccountNumber(rs.getString("account_number"));
        customer.setFirstName(rs.getString("first_name"));
        customer.setLastName(rs.getString("last_name"));
        customer.setEmail(rs.getString("email"));
        customer.setPhone(rs.getString("phone"));
        customer.setAddressLine1(rs.getString("address_line1"));
        customer.setAddressLine2(rs.getString("address_line2"));
        customer.setCity(rs.getString("city"));
        customer.setState(rs.getString("state"));
        customer.setPostalCode(rs.getString("postal_code"));
        customer.setCountry(rs.getString("country"));
        customer.setDateOfBirth(rs.getDate("date_of_birth"));
        customer.setGender(rs.getString("gender"));
        customer.setUnitsConsumed(rs.getInt("units_consumed"));
        customer.setCreditLimit(rs.getBigDecimal("credit_limit"));
        customer.setStatus(rs.getString("status"));
        customer.setCreatedAt(rs.getTimestamp("created_at"));
        customer.setUpdatedAt(rs.getTimestamp("updated_at"));
        customer.setCreatedBy(rs.getInt("created_by"));
        return customer;
    }
}
