<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bill List - Pahana Edu</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
</head>
<body>
    <jsp:include page="/views/includes/navbar.jsp"/>
    
    <div class="container mt-4">
        <div class="row">
            <div class="col-12">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2>Bill Management</h2>
                    <a href="${pageContext.request.contextPath}/billing/generate" class="btn btn-primary">Generate New Bill</a>
                </div>
                
                <c:if test="${not empty success}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        ${success}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>
                
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        ${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>
                
                <div class="card">
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${empty bills}">
                                <div class="text-center py-4">
                                    <p class="text-muted">No bills found.</p>
                                    <a href="${pageContext.request.contextPath}/billing/generate" class="btn btn-primary">Generate First Bill</a>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="table-responsive">
                                    <table class="table table-striped">
                                        <thead>
                                            <tr>
                                                <th>Bill Number</th>
                                                <th>Customer</th>
                                                <th>Bill Date</th>
                                                <th>Due Date</th>
                                                <th>Total Amount</th>
                                                <th>Status</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="bill" items="${bills}">
                                                <tr>
                                                    <td>${bill.billNumber}</td>
                                                    <td>
                                                        <strong>${bill.customerName}</strong><br>
                                                        <small class="text-muted">${bill.customerAccountNumber}</small>
                                                    </td>
                                                    <td><fmt:formatDate value="${bill.billDate}" pattern="MMM dd, yyyy"/></td>
                                                    <td><fmt:formatDate value="${bill.dueDate}" pattern="MMM dd, yyyy"/></td>
                                                    <td>$<fmt:formatNumber value="${bill.totalAmount}" pattern="#,##0.00"/></td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${bill.status == 'paid'}">
                                                                <span class="badge bg-success">Paid</span>
                                                            </c:when>
                                                            <c:when test="${bill.status == 'sent'}">
                                                                <span class="badge bg-warning">Sent</span>
                                                            </c:when>
                                                            <c:when test="${bill.status == 'overdue'}">
                                                                <span class="badge bg-danger">Overdue</span>
                                                            </c:when>
                                                            <c:when test="${bill.status == 'draft'}">
                                                                <span class="badge bg-secondary">Draft</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-light text-dark">${bill.status}</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <a href="${pageContext.request.contextPath}/billing/view?id=${bill.id}" 
                                                           class="btn btn-sm btn-outline-primary">View</a>
                                                        <c:if test="${bill.status != 'paid'}">
                                                            <div class="btn-group" role="group">
                                                                <button type="button" class="btn btn-sm btn-outline-success dropdown-toggle" 
                                                                        data-bs-toggle="dropdown">Mark Paid</button>
                                                                <ul class="dropdown-menu">
                                                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/billing/pay?id=${bill.id}&method=cash">Cash</a></li>
                                                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/billing/pay?id=${bill.id}&method=credit_card">Credit Card</a></li>
                                                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/billing/pay?id=${bill.id}&method=bank_transfer">Bank Transfer</a></li>
                                                                </ul>
                                                            </div>
                                                        </c:if>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
