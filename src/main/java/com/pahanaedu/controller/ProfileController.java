package com.pahanaedu.controller;

import com.pahanaedu.model.User;
import com.pahanaedu.service.UserService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/profile")
public class ProfileController extends HttpServlet {
    private UserService userService;

    @Override
    public void init() {
        this.userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // Must be logged in
        HttpSession session = req.getSession(false);
        User sessionUser = (session != null) ? (User)session.getAttribute("user") : null;
        if (sessionUser == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }

        // Reload fresh data
        User user = userService.getById(sessionUser.getId());
        req.setAttribute("user", user);
        req.getRequestDispatcher("/views/profile.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User sessionUser = (session != null) ? (User)session.getAttribute("user") : null;
        if (sessionUser == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }

        // Build updated user
        User updated = new User();
        updated.setId(sessionUser.getId());
        updated.setUsername(req.getParameter("username"));
        updated.setEmail(req.getParameter("email"));
        updated.setFullName(req.getParameter("fullName"));
        // If you let them change password:
        String pw = req.getParameter("password");
        if (pw != null && !pw.isBlank()) {
            updated.setPassword(pw);
        } else {
            updated.setPassword(sessionUser.getPassword());
        }
        updated.setRole(sessionUser.getRole());
        updated.setStatus(sessionUser.getStatus());

        // Attempt update
        if (userService.updateUser(updated)) {
            session.setAttribute("user", updated);
            req.setAttribute("success", "Profile updated successfully!");
        } else {
            req.setAttribute("error", "Failed to update profile.");
        }

        req.setAttribute("user", updated);
        req.getRequestDispatcher("/views/profile.jsp").forward(req, resp);
    }
}
