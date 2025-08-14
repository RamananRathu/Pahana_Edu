package com.pahanaedu.controller;

import com.pahanaedu.service.CustomerService;
import com.pahanaedu.service.ItemService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/dashboard")
public class DashboardController extends HttpServlet {
    private CustomerService customerService;
    private ItemService itemService;

    @Override
    public void init() throws ServletException {
        this.customerService = new CustomerService();
        this.itemService     = new ItemService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // Fetch counts
        int customerCount = customerService.getAllCustomers().size();
        int itemCount     = itemService.getAllItems().size();

        // Make them available to JSP
        req.setAttribute("customerCount", customerCount);
        req.setAttribute("itemCount",     itemCount);

        // Forward to dashboard view
        req.getRequestDispatcher("/views/dashboard.jsp")
           .forward(req, resp);
    }
}
