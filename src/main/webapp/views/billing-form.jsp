<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Generate Bill - Pahana Edu</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
</head>
<body>
    
    <jsp:include page="/views/includes/navbar.jsp"/>
    
    <div class="container mt-4">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header">
                        <h3>Generate Bill</h3>
                    </div>
                    <div class="card-body">
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger" role="alert">
                                ${error}
                            </div>
                        </c:if>
                        
                        <form method="post" action="${pageContext.request.contextPath}/billing/generate">
                            <div class="mb-3">
                                <label for="customerId" class="form-label">Select Customer *</label>
                                <select class="form-select" id="customerId" name="customerId" required>
                                    <option value="">Choose a customer...</option>
                                    <c:forEach var="customer" items="${customers}">
                                        <option value="${customer.id}">
                                            ${customer.accountNumber} - ${customer.fullName} (${customer.unitsConsumed} units)
                                        </option>
                                    </c:forEach>
                                </select>
                                <div class="form-text">Select the customer for whom you want to generate a bill.</div>
                            </div>
                            
                            <div class="alert alert-info">
                                <h6><i class="bi bi-info-circle"></i> Billing Information</h6>
                                <ul class="mb-0">
                                    <li>Bills are calculated based on units consumed at $2.50 per unit</li>
                                    <li>Tax rate: 8.25%</li>
                                    <li>Due date: 30 days from bill date</li>
                                </ul>
                            </div>
                            
                            <div class="d-flex justify-content-between">
                                <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-secondary">Back to Dashboard</a>
                                <div>
                                    <a href="${pageContext.request.contextPath}/billing/list" class="btn btn-outline-primary me-2">View All Bills</a>
                                    <button type="submit" class="btn btn-primary">Generate Bill</button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
