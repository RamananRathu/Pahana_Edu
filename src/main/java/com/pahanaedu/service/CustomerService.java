package com.pahanaedu.service;

import com.pahanaedu.dao.CustomerDAO;
import com.pahanaedu.model.Customer;
import java.util.List;
import java.util.ArrayList;
import java.util.logging.Logger;
import java.util.logging.Level;

public class CustomerService {
    private static final Logger LOGGER = Logger.getLogger(CustomerService.class.getName());
    private CustomerDAO customerDAO;
    
    public CustomerService() {
        try {
            this.customerDAO = new CustomerDAO();
            LOGGER.info("CustomerService initialized successfully");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Failed to initialize CustomerDAO", e);
            throw new RuntimeException("Failed to initialize CustomerService", e);
        }
    }
    
    public List<Customer> getAllCustomers() {
        try {
            LOGGER.info("Fetching all customers");
            List<Customer> customers = customerDAO.findAll();
            LOGGER.info("Successfully retrieved " + (customers != null ? customers.size() : 0) + " customers");
            return customers != null ? customers : new ArrayList<>();
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error fetching all customers", e);
            // Return empty list instead of letting exception bubble up
            return new ArrayList<>();
        }
    }
    
    public Customer getCustomerById(int id) {
        try {
            LOGGER.info("Fetching customer with ID: " + id);
            return customerDAO.findById(id);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error fetching customer with ID: " + id, e);
            return null;
        }
    }
    
    public Customer getCustomerByAccountNumber(String accountNumber) {
        try {
            if (accountNumber == null || accountNumber.trim().isEmpty()) {
                LOGGER.warning("Account number is null or empty");
                return null;
            }
            return customerDAO.findByAccountNumber(accountNumber);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error fetching customer with account number: " + accountNumber, e);
            return null;
        }
    }
    
    public boolean createCustomer(Customer customer) {
        try {
            if (customer == null || customer.getAccountNumber() == null || customer.getFirstName() == null) {
                LOGGER.warning("Invalid customer data provided");
                return false;
            }
            
            // Check if account number already exists
            if (customerDAO.findByAccountNumber(customer.getAccountNumber()) != null) {
                LOGGER.warning("Account number already exists: " + customer.getAccountNumber());
                return false;
            }
            
            boolean result = customerDAO.save(customer);
            LOGGER.info("Customer creation " + (result ? "successful" : "failed") + " for account: " + customer.getAccountNumber());
            return result;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error creating customer", e);
            return false;
        }
    }
    
    public boolean updateCustomer(Customer customer) {
        try {
            if (customer == null || customer.getId() <= 0) {
                LOGGER.warning("Invalid customer data for update");
                return false;
            }
            
            boolean result = customerDAO.update(customer);
            LOGGER.info("Customer update " + (result ? "successful" : "failed") + " for ID: " + customer.getId());
            return result;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error updating customer with ID: " + (customer != null ? customer.getId() : "unknown"), e);
            return false;
        }
    }
    
    public boolean deleteCustomer(int id) {
        try {
            boolean result = customerDAO.delete(id);
            LOGGER.info("Customer deletion " + (result ? "successful" : "failed") + " for ID: " + id);
            return result;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error deleting customer with ID: " + id, e);
            return false;
        }
    }
    
    public boolean isAccountNumberExists(String accountNumber) {
        try {
            if (accountNumber == null || accountNumber.trim().isEmpty()) {
                return false;
            }
            return customerDAO.findByAccountNumber(accountNumber) != null;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error checking account number existence: " + accountNumber, e);
            return false;
        }
    }
    
    public List<Customer> searchCustomers(String searchTerm) {
        try {
            if (searchTerm == null || searchTerm.trim().isEmpty()) {
                LOGGER.info("Empty search term, returning all customers");
                return getAllCustomers();
            }
            
            List<Customer> results = customerDAO.searchCustomers(searchTerm.trim());
            LOGGER.info("Search completed for term: " + searchTerm + ", found " + (results != null ? results.size() : 0) + " results");
            return results != null ? results : new ArrayList<>();
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error searching customers with term: " + searchTerm, e);
            return new ArrayList<>();
        }
    }
    
    // Add a method to test if the service is working
    public boolean isServiceHealthy() {
        try {
            // Simple test to see if DAO is accessible
            customerDAO.findAll();
            return true;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Service health check failed", e);
            return false;
        }
    }
}