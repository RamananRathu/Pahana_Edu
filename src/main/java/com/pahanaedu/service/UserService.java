package com.pahanaedu.service;

import com.pahanaedu.dao.UserDAO;
import com.pahanaedu.model.User;
import java.util.List;

public class UserService {
    private final UserDAO userDAO;
    
    public UserService() {
        this.userDAO = new UserDAO();
    }
    
    public User authenticate(String username, String password) {
        if (username == null || password == null
         || username.trim().isEmpty() || password.trim().isEmpty()) {
            return null;
        }
        return userDAO.authenticate(username.trim(), password);
    }
    
    public List<User> getAllUsers() {
        return userDAO.findAll();
    }
    
    /** Alias for ProfileController.getById */
    public User getById(int id) {
        return userDAO.findById(id);
    }

    /** You already had this—you could keep it or direct callers to getById */
    public User getUserById(int id) {
        return userDAO.findById(id);
    }
    
    public User getUserByUsername(String username) {
        return userDAO.findByUsername(username);
    }
    
    public boolean createUser(User user) {
        if (user == null 
         || user.getUsername() == null 
         || user.getPassword() == null) {
            return false;
        }
        if (userDAO.findByUsername(user.getUsername()) != null) {
            return false;
        }
        return userDAO.save(user);
    }
    
    public boolean updateUser(User user) {
        if (user == null || user.getId() <= 0) {
            return false;
        }
        return userDAO.update(user);
    }
    
    public boolean deleteUser(int id) {
        return userDAO.delete(id);
    }
    
    public boolean isUsernameExists(String username) {
        return userDAO.findByUsername(username) != null;
    }
}
