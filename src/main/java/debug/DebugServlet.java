package debug;

import com.pahanaedu.config.DatabaseConfig;
import com.pahanaedu.dao.CustomerDAO;
import com.pahanaedu.model.Customer;
import com.pahanaedu.service.CustomerService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;

@WebServlet("/debug")
public class DebugServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        out.println("<!DOCTYPE html>");
        out.println("<html><head><title>Debug Results</title></head><body>");
        out.println("<h1>Database Debug Information</h1>");
        
        // Test 1: MySQL Driver
        out.println("<h2>1. MySQL Driver Test</h2>");
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            out.println("<p style='color:green'>✅ MySQL JDBC Driver loaded successfully</p>");
        } catch (ClassNotFoundException e) {
            out.println("<p style='color:red'>❌ MySQL JDBC Driver not found: " + e.getMessage() + "</p>");
            out.println("<p><strong>This is likely your problem!</strong></p>");
        }
        
        // Test 2: Database Connection
        out.println("<h2>2. Database Connection Test</h2>");
        try {
            boolean connected = DatabaseConfig.testConnection();
            if (connected) {
                out.println("<p style='color:green'>✅ Database connection successful</p>");
            } else {
                out.println("<p style='color:red'>❌ Database connection failed</p>");
            }
        } catch (Exception e) {
            out.println("<p style='color:red'>❌ Database connection error: " + e.getMessage() + "</p>");
            out.println("<pre style='background:#f5f5f5; padding:10px'>");
            e.printStackTrace(out);
            out.println("</pre>");
        }
        
        // Test 3: Database Query
        out.println("<h2>3. Database Query Test</h2>");
        try (Connection conn = DatabaseConfig.getConnection()) {
            
            // Check if database exists
            String sql = "SELECT DATABASE() as current_db";
            try (PreparedStatement stmt = conn.prepareStatement(sql);
                 ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    String dbName = rs.getString("current_db");
                    out.println("<p>✅ Connected to database: <strong>" + dbName + "</strong></p>");
                }
            }
            
            // Check if customers table exists
            sql = "SHOW TABLES LIKE 'customers'";
            try (PreparedStatement stmt = conn.prepareStatement(sql);
                 ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    out.println("<p style='color:green'>✅ Customers table exists</p>");
                } else {
                    out.println("<p style='color:red'>❌ Customers table does not exist</p>");
                    out.println("<p><strong>Solution:</strong> Run your SQL schema script!</p>");
                }
            }
            
            // Check users table (for foreign key)
            sql = "SHOW TABLES LIKE 'users'";
            try (PreparedStatement stmt = conn.prepareStatement(sql);
                 ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    out.println("<p style='color:green'>✅ Users table exists</p>");
                    
                    // Check if there are any users
                    sql = "SELECT COUNT(*) as count FROM users";
                    try (PreparedStatement countStmt = conn.prepareStatement(sql);
                         ResultSet countRs = countStmt.executeQuery()) {
                        if (countRs.next()) {
                            int userCount = countRs.getInt("count");
                            if (userCount > 0) {
                                out.println("<p style='color:green'>✅ Found " + userCount + " users in database</p>");
                            } else {
                                out.println("<p style='color:orange'>⚠️ Users table is empty - you need to create a user first</p>");
                            }
                        }
                    }
                } else {
                    out.println("<p style='color:red'>❌ Users table does not exist</p>");
                }
            }
            
        } catch (Exception e) {
            out.println("<p style='color:red'>❌ Database query failed: " + e.getMessage() + "</p>");
            out.println("<pre style='background:#f5f5f5; padding:10px'>");
            e.printStackTrace(out);
            out.println("</pre>");
        }
        
        // Test 4: CustomerDAO
        out.println("<h2>4. CustomerDAO Test</h2>");
        try {
            CustomerDAO dao = new CustomerDAO();
            out.println("<p style='color:green'>✅ CustomerDAO created successfully</p>");
            
            List<Customer> customers = dao.findAll();
            out.println("<p style='color:green'>✅ CustomerDAO.findAll() executed successfully</p>");
            out.println("<p>Found " + customers.size() + " customers</p>");
            
        } catch (Exception e) {
            out.println("<p style='color:red'>❌ CustomerDAO failed: " + e.getMessage() + "</p>");
            out.println("<pre style='background:#f5f5f5; padding:10px'>");
            e.printStackTrace(out);
            out.println("</pre>");
        }
        
        // Test 5: CustomerService
        out.println("<h2>5. CustomerService Test</h2>");
        try {
            CustomerService service = new CustomerService();
            out.println("<p style='color:green'>✅ CustomerService created successfully</p>");
            
            List<Customer> customers = service.getAllCustomers();
            out.println("<p style='color:green'>✅ CustomerService.getAllCustomers() executed successfully</p>");
            out.println("<p>Found " + customers.size() + " customers</p>");
            
        } catch (Exception e) {
            out.println("<p style='color:red'>❌ CustomerService failed: " + e.getMessage() + "</p>");
            out.println("<pre style='background:#f5f5f5; padding:10px'>");
            e.printStackTrace(out);
            out.println("</pre>");
        }
        
        // Connection info
        out.println("<h2>6. Connection Details</h2>");
        out.println("<p><strong>Database URL:</strong> jdbc:mysql://localhost:3306/pahana_edu</p>");
        out.println("<p><strong>Username:</strong> root</p>");
        out.println("<p><strong>MySQL Version Check:</strong></p>");
        
        try (Connection conn = DatabaseConfig.getConnection()) {
            String sql = "SELECT VERSION() as version";
            try (PreparedStatement stmt = conn.prepareStatement(sql);
                 ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    String version = rs.getString("version");
                    out.println("<p>✅ MySQL Version: " + version + "</p>");
                }
            }
        } catch (Exception e) {
            out.println("<p style='color:red'>❌ Could not get MySQL version: " + e.getMessage() + "</p>");
        }
        
        out.println("</body></html>");
    }
}