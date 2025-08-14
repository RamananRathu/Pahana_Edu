package com.pahanaedu.controller;

import com.pahanaedu.model.Bill;
import com.pahanaedu.model.Customer;
import com.pahanaedu.model.User;
import com.pahanaedu.service.BillingService;
import com.pahanaedu.service.CustomerService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/billing/*")
public class BillingController extends HttpServlet {
    private BillingService billingService;
    private CustomerService customerService;
    
    @Override
    public void init() throws ServletException {
        billingService = new BillingService();
        customerService = new CustomerService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = getAction(request);
        
        switch (action) {
            case "":
            case "generate":
                showBillingForm(request, response);
                break;
            case "view":
                viewBill(request, response);
                break;
            case "list":
                listBills(request, response);
                break;
            case "pay":
                markBillAsPaid(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/billing/generate");
                break;
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = getAction(request);
        
        if ("generate".equals(action)) {
            generateBill(request, response);
        }
    }
    
    private void showBillingForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Customer> customers = customerService.getAllCustomers();
        request.setAttribute("customers", customers);
        request.getRequestDispatcher("/views/billing-form.jsp").forward(request, response);
    }
    
    private void generateBill(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String customerIdStr = request.getParameter("customerId");
        
        if (customerIdStr != null && !customerIdStr.trim().isEmpty()) {
            try {
                int customerId = Integer.parseInt(customerIdStr);
                HttpSession session = request.getSession();
                User user = (User) session.getAttribute("user");
                
                Bill bill = billingService.generateBill(customerId, user.getId());
                
                if (bill != null) {
                    if (billingService.saveBill(bill)) {
                        request.setAttribute("bill", bill);
                        request.getRequestDispatcher("/views/bill-view.jsp").forward(request, response);
                    } else {
                        request.setAttribute("error", "Failed to save bill!");
                        showBillingForm(request, response);
                    }
                } else {
                    request.setAttribute("error", "Customer not found!");
                    showBillingForm(request, response);
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid customer selection!");
                showBillingForm(request, response);
            }
        } else {
            request.setAttribute("error", "Please select a customer!");
            showBillingForm(request, response);
        }
    }
    
    private void viewBill(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String billIdStr = request.getParameter("id");
        
        if (billIdStr != null) {
            try {
                int billId = Integer.parseInt(billIdStr);
                Bill bill = billingService.getBillById(billId);
                
                if (bill != null) {
                    request.setAttribute("bill", bill);
                    request.getRequestDispatcher("/views/bill-view.jsp").forward(request, response);
                } else {
                    response.sendRedirect(request.getContextPath() + "/billing/list");
                }
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/billing/list");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/billing/list");
        }
    }
    
    private void listBills(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Bill> bills = billingService.getAllBills();
        request.setAttribute("bills", bills);
        request.getRequestDispatcher("/views/bill-list.jsp").forward(request, response);
    }
    
    private void markBillAsPaid(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        String billIdStr = request.getParameter("id");
        String paymentMethod = request.getParameter("method");
        
        if (billIdStr != null && paymentMethod != null) {
            try {
                int billId = Integer.parseInt(billIdStr);
                if (billingService.markBillAsPaid(billId, paymentMethod)) {
                    request.getSession().setAttribute("success", "Bill marked as paid successfully!");
                } else {
                    request.getSession().setAttribute("error", "Failed to update bill payment status!");
                }
            } catch (NumberFormatException e) {
                request.getSession().setAttribute("error", "Invalid bill ID!");
            }
        }
        response.sendRedirect(request.getContextPath() + "/billing/list");
    }
    
    private String getAction(HttpServletRequest request) {
        String pathInfo = request.getPathInfo();
        return pathInfo != null ? pathInfo.substring(1) : "";
    }
}
