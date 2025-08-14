<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Help - Pahana Edu</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
</head>
<body>
    <%@ include file="includes/navbar.jsp" %>
    
    <div class="container mt-4">
        <div class="row">
            <div class="col-12">
                <h1>Help & Documentation</h1>
                <p class="lead">Welcome to the Pahana Edu help system. Here you'll find information on how to use all features of the application.</p>
            </div>
        </div>
        
        <div class="row mt-4">
            <div class="col-md-8">
                <div class="card">
                    <div class="card-body">
                        <h3>Getting Started</h3>
                        <p>Pahana Edu is a comprehensive education management system that helps you manage customers, items, and billing efficiently.</p>
                        
                        <h4>Login Credentials</h4>
                        <ul>
                            <li><strong>Admin:</strong> Username: admin, Password: admin123</li>
                            <li><strong>User:</strong> Username: user, Password: user123</li>
                        </ul>
                        
                        <h4>Customer Management</h4>
                        <p>The customer management module allows you to:</p>
                        <ul>
                            <li>Add new customers with account numbers, names, addresses, phone numbers, and units</li>
                            <li>Edit existing customer information</li>
                            <li>Delete customers from the system</li>
                            <li>View a complete list of all customers</li>
                        </ul>
                        
                        <h4>Item Management</h4>
                        <p>The item management module helps you:</p>
                        <ul>
                            <li>Add new book items with ID, title, author, price, and stock information</li>
                            <li>Update item details including pricing and stock levels</li>
                            <li>Remove items from inventory</li>
                            <li>Track stock levels for all items</li>
                        </ul>
                        
                        <h4>Billing System</h4>
                        <p>The billing system provides:</p>
                        <ul>
                            <li>Automatic bill generation based on customer units consumed</li>
                            <li>Fixed rate calculation at $2.50 per unit</li>
                            <li>Printable bill format</li>
                            <li>Bill tracking with unique bill IDs</li>
                        </ul>
                        
                        <h4>Navigation</h4>
                        <p>Use the navigation bar at the top to access different modules:</p>
                        <ul>
                            <li><strong>Dashboard:</strong> Overview of the system</li>
                            <li><strong>Customers:</strong> Customer management</li>
                            <li><strong>Items:</strong> Item inventory management</li>
                            <li><strong>Billing:</strong> Bill generation</li>
                            <li><strong>Help:</strong> This help page</li>
                        </ul>
                        
                        <h4>Data Storage</h4>
                        <p>All data is stored in plain text files located in the <code>data/</code> directory:</p>
                        <ul>
                            <li><code>users.txt</code> - User authentication data</li>
                            <li><code>customers.txt</code> - Customer information</li>
                            <li><code>items.txt</code> - Item inventory data</li>
                        </ul>
                        
                        <h4>Security Features</h4>
                        <ul>
                            <li>Session-based authentication</li>
                            <li>Automatic logout on session timeout</li>
                            <li>Protected pages requiring login</li>
                        </ul>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="card">
                    <div class="card-header">
                        <h5>Quick Links</h5>
                    </div>
                    <div class="card-body">
                        <div class="d-grid gap-2">
                            <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-outline-primary">Dashboard</a>
                            <a href="${pageContext.request.contextPath}/customers/list" class="btn btn-outline-primary">Manage Customers</a>
                            <a href="${pageContext.request.contextPath}/items/list" class="btn btn-outline-primary">Manage Items</a>
                            <a href="${pageContext.request.contextPath}/billing/generate" class="btn btn-outline-primary">Generate Bills</a>
                        </div>
                    </div>
                </div>
                
                <div class="card mt-3">
                    <div class="card-header">
                        <h5>System Information</h5>
                    </div>
                    <div class="card-body">
                        <p><strong>Version:</strong> 1.0.0</p>
                        <p><strong>Architecture:</strong> MVC Pattern</p>
                        <p><strong>Storage:</strong> File-based</p>
                        <p><strong>Framework:</strong> Java Servlets & JSP</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
