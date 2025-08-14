package com.pahanaedu.service;

import com.pahanaedu.dao.BillDAO;
import com.pahanaedu.model.Bill;
import com.pahanaedu.model.BillItem;
import com.pahanaedu.model.Customer;
import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class BillingService {
    private BillDAO billDAO;
    private CustomerService customerService;
    
    public BillingService() {
        this.billDAO = new BillDAO();
        this.customerService = new CustomerService();
    }
    
    public Bill generateBill(int customerId, int createdBy) {
        Customer customer = customerService.getCustomerById(customerId);
        if (customer == null) {
            return null;
        }
        
        // Generate bill number
        String billNumber = "BILL-" + System.currentTimeMillis();
        
        // Create bill
        Bill bill = new Bill();
        bill.setBillNumber(billNumber);
        bill.setCustomerId(customer.getId());
        bill.setCustomerName(customer.getFullName());
        bill.setCustomerAccountNumber(customer.getAccountNumber());
        bill.setBillDate(new Timestamp(System.currentTimeMillis()));
        bill.setDueDate(Date.valueOf(LocalDate.now().plusDays(30)));
        bill.setCreatedBy(createdBy);
        
        // Create bill items for units consumed
        List<BillItem> billItems = new ArrayList<>();
        if (customer.getUnitsConsumed() > 0) {
            BillItem unitItem = new BillItem();
            unitItem.setDescription("Units Consumed - " + customer.getAccountNumber());
            unitItem.setQuantity(customer.getUnitsConsumed());
            unitItem.setUnitPrice(new BigDecimal("2.50")); // Default rate per unit
            unitItem.setLineTotal(unitItem.getUnitPrice().multiply(new BigDecimal(unitItem.getQuantity())));
            billItems.add(unitItem);
        }
        
        bill.setBillItems(billItems);
        bill.calculateTotals();
        bill.setStatus("sent");
        
        return bill;
    }
    
    public boolean saveBill(Bill bill) {
        return billDAO.save(bill);
    }
    
    public List<Bill> getAllBills() {
        return billDAO.findAll();
    }
    
    public Bill getBillById(int id) {
        return billDAO.findById(id);
    }
    
    public Bill getBillByNumber(String billNumber) {
        return billDAO.findByBillNumber(billNumber);
    }
    
    public List<Bill> getCustomerBills(int customerId) {
        return billDAO.findByCustomerId(customerId);
    }
    
    public boolean updateBill(Bill bill) {
        return billDAO.update(bill);
    }
    
    public boolean deleteBill(int id) {
        return billDAO.delete(id);
    }
    
    public boolean markBillAsPaid(int billId, String paymentMethod) {
        Bill bill = billDAO.findById(billId);
        if (bill != null) {
            bill.setPaidAmount(bill.getTotalAmount());
            bill.setBalanceAmount(BigDecimal.ZERO);
            bill.setStatus("paid");
            bill.setPaymentMethod(paymentMethod);
            bill.setPaymentDate(new Timestamp(System.currentTimeMillis()));
            return billDAO.update(bill);
        }
        return false;
    }
}
