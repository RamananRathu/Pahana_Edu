package com.pahanaedu.controller;

import com.pahanaedu.model.Customer;
import com.pahanaedu.model.User;
import com.pahanaedu.service.CustomerService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.util.List;

@WebServlet({"/customers", "/customers/*"})
public class CustomerController extends HttpServlet {
    private CustomerService customerService;

    @Override
    public void init() throws ServletException {
        customerService = new CustomerService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) action = "";

        switch (action) {
            case "add":
                req.getRequestDispatcher("/views/customer-form.jsp")
                   .forward(req, resp);
                return;

            case "edit":
                try {
                    int id = Integer.parseInt(req.getParameter("id"));
                    Customer cust = customerService.getCustomerById(id);
                    if (cust != null) {
                        req.setAttribute("customer", cust);
                        req.setAttribute("isEdit", true);
                        req.getRequestDispatcher("/views/customer-form.jsp")
                           .forward(req, resp);
                        return;
                    }
                } catch (NumberFormatException ignored) {}
                resp.sendRedirect(req.getContextPath() + "/customers");
                return;

            case "delete":
                try {
                    int id = Integer.parseInt(req.getParameter("id"));
                    boolean ok = customerService.deleteCustomer(id);
                    req.getSession().setAttribute(
                        ok ? "success" : "error",
                        ok ? "Customer deleted." : "Delete failed."
                    );
                } catch (NumberFormatException e) {
                    req.getSession().setAttribute("error","Invalid customer ID!");
                }
                resp.sendRedirect(req.getContextPath() + "/customers");
                return;

            case "search":
                String q = req.getParameter("q");
                List<Customer> results = customerService.searchCustomers(q);
                req.setAttribute("customers", results);
                req.setAttribute("searchTerm", q);
                req.getRequestDispatcher("/views/customer-list.jsp")
                   .forward(req, resp);
                return;

            case "list":
            case "":
            default:
                List<Customer> all = customerService.getAllCustomers();
                req.setAttribute("customers", all);
                req.getRequestDispatcher("/views/customer-list.jsp")
                   .forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) action = "";

        switch (action) {
            case "add":
                doAdd(req, resp);
                break;
            case "update":
                doUpdate(req, resp);
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/customers");
        }
    }

    private void doAdd(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            Customer c = buildCustomer(req);
            User u = (User)req.getSession().getAttribute("user");
            c.setCreatedBy(u.getId());

            boolean ok = customerService.createCustomer(c);
            req.getSession().setAttribute(
                ok ? "success" : "error",
                ok ? "Customer added successfully!" : "Account exists or invalid data!"
            );
            resp.sendRedirect(req.getContextPath() + "/customers");
        } catch (Exception e) {
            req.setAttribute("error", "Error adding customer: " + e.getMessage());
            req.getRequestDispatcher("/views/customer-form.jsp")
               .forward(req, resp);
        }
    }

    private void doUpdate(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            Customer c = buildCustomer(req);
            c.setId(Integer.parseInt(req.getParameter("id")));

            boolean ok = customerService.updateCustomer(c);
            req.getSession().setAttribute(
                ok ? "success" : "error",
                ok ? "Customer updated successfully!" : "Update failed!"
            );
            resp.sendRedirect(req.getContextPath() + "/customers");
        } catch (Exception e) {
            req.setAttribute("error", "Error updating customer: " + e.getMessage());
            req.getRequestDispatcher("/views/customer-form.jsp")
               .forward(req, resp);
        }
    }

    private Customer buildCustomer(HttpServletRequest req) {
        Customer c = new Customer();
        c.setAccountNumber(req.getParameter("accountNumber"));
        c.setFirstName(req.getParameter("firstName"));
        c.setLastName(req.getParameter("lastName"));
        c.setEmail(req.getParameter("email"));
        c.setPhone(req.getParameter("phone"));
        c.setAddressLine1(req.getParameter("addressLine1"));
        c.setAddressLine2(req.getParameter("addressLine2"));
        c.setCity(req.getParameter("city"));
        c.setState(req.getParameter("state"));
        c.setPostalCode(req.getParameter("postalCode"));
        c.setCountry(req.getParameter("country"));
        String dob = req.getParameter("dateOfBirth");
        if (dob != null && !dob.isBlank()) {
            c.setDateOfBirth(Date.valueOf(dob));
        }
        String units = req.getParameter("unitsConsumed");
        if (units != null && !units.isBlank()) {
            c.setUnitsConsumed(Integer.parseInt(units));
        }
        String credit = req.getParameter("creditLimit");
        if (credit != null && !credit.isBlank()) {
            c.setCreditLimit(new BigDecimal(credit));
        }
        return c;
    }
}
