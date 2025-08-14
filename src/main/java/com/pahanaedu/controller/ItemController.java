package com.pahanaedu.controller;

import com.pahanaedu.model.Item;
import com.pahanaedu.service.ItemService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet({"/items", "/items/*"})
public class ItemController extends HttpServlet {
    private ItemService itemService;

    @Override
    public void init() { 
        this.itemService = new ItemService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // Read action from ?action=add,edit,delete,list
        String action = req.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "add":
                // Show blank form
                req.getRequestDispatcher("/views/item-form.jsp")
                   .forward(req, resp);
                break;

            case "edit":
                // Load existing item
                try {
                    int id = Integer.parseInt(req.getParameter("id"));
                    Item item = itemService.getItemById(id);
                    if (item != null) {
                        req.setAttribute("item", item);
                        req.setAttribute("isEdit", true);
                        req.getRequestDispatcher("/views/item-form.jsp")
                           .forward(req, resp);
                    } else {
                        resp.sendRedirect(req.getContextPath() + "/items");
                    }
                } catch (NumberFormatException e) {
                    resp.sendRedirect(req.getContextPath() + "/items");
                }
                break;

            case "delete":
                // Delete & go back to list
                try {
                    int id = Integer.parseInt(req.getParameter("id"));
                    itemService.deleteItem(id);
                } catch (Exception ignored) {}
                resp.sendRedirect(req.getContextPath() + "/items");
                break;

            case "list":
            default:
                // Default: show list
                List<Item> items = itemService.getAllItems();
                req.setAttribute("items", items);
                req.getRequestDispatcher("/views/item-list.jsp")
                   .forward(req, resp);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) action = "";

        switch (action) {
            case "add":
                handleAdd(req, resp);
                break;
            case "update":
                handleUpdate(req, resp);
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/items");
        }
    }

    private void handleAdd(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            Item item = new Item();
            item.setItemCode(req.getParameter("itemCode"));
            item.setTitle(req.getParameter("title"));
            item.setPrice(new BigDecimal(req.getParameter("price")));
            item.setStockQuantity(Integer.parseInt(req.getParameter("stock")));
            if (itemService.createItem(item)) {
                resp.sendRedirect(req.getContextPath() + "/items");
            } else {
                req.setAttribute("error", "Item code already exists");
                req.getRequestDispatcher("/views/item-form.jsp")
                   .forward(req, resp);
            }
        } catch (Exception e) {
            req.setAttribute("error", "Invalid input: " + e.getMessage());
            req.getRequestDispatcher("/views/item-form.jsp")
               .forward(req, resp);
        }
    }

    private void handleUpdate(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            Item item = new Item();
            item.setId(Integer.parseInt(req.getParameter("id")));
            item.setTitle(req.getParameter("title"));
            item.setPrice(new BigDecimal(req.getParameter("price")));
            item.setStockQuantity(Integer.parseInt(req.getParameter("stock")));
            if (itemService.updateItem(item)) {
                resp.sendRedirect(req.getContextPath() + "/items");
            } else {
                req.setAttribute("error", "Update failed");
                req.setAttribute("item", item);
                req.setAttribute("isEdit", true);
                req.getRequestDispatcher("/views/item-form.jsp")
                   .forward(req, resp);
            }
        } catch (Exception e) {
            req.setAttribute("error", "Invalid input: " + e.getMessage());
            req.getRequestDispatcher("/views/item-form.jsp")
               .forward(req, resp);
        }
    }
}
