<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Customer List - Pahana Edu</title>
  <link
    href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css"
    rel="stylesheet"
  >
  <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
</head>
<body>

  <%@ include file="includes/navbar.jsp" %>

  <div class="container mt-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
      <h2>Customer Management</h2>
      <a
        href="${pageContext.request.contextPath}/customers?action=add"
        class="btn btn-primary"
      >
        Add New Customer
      </a>
    </div>

    <!-- Success/Error flash messages -->
    <c:if test="${not empty success}">
      <div class="alert alert-success">${success}</div>
    </c:if>
    <c:if test="${not empty error}">
      <div class="alert alert-danger">${error}</div>
    </c:if>

    <div class="card">
      <div class="card-body">
        <c:choose>
          <c:when test="${empty customers}">
            <div class="text-center py-4">
              <p class="text-muted">No customers found.</p>
              <a
                href="${pageContext.request.contextPath}/customers?action=add"
                class="btn btn-primary"
              >
                Add First Customer
              </a>
            </div>
          </c:when>
          <c:otherwise>
            <div class="table-responsive">
              <table class="table table-striped">
                <thead>
                  <tr>
                    <th>Account #</th>
                    <th>Name</th>
                    <th>Address</th>
                    <th>Phone</th>
                    <th>Units</th>
                    <th>Actions</th>
                  </tr>
                </thead>
                <tbody>
                  <c:forEach var="cust" items="${customers}">
                    <tr>
                      <!-- Account Number -->
                      <td>${cust.accountNumber}</td>

                      <!-- Full Name -->
                      <td>${cust.fullName}</td>

                      <!-- Full Address -->
                      <td>${cust.fullAddress}</td>

                      <!-- Phone -->
                      <td>${cust.phone}</td>

                      <!-- Units Consumed -->
                      <td>${cust.unitsConsumed}</td>

                      <!-- Actions -->
                      <td>
                        <a
                          href="${pageContext.request.contextPath}/customers?action=edit&amp;id=${cust.id}"
                          class="btn btn-sm btn-outline-primary"
                        >
                          Edit
                        </a>
                        <a
                          href="${pageContext.request.contextPath}/customers?action=delete&amp;id=${cust.id}"
                          class="btn btn-sm btn-outline-danger"
                          onclick="return confirm('Delete this customer?');"
                        >
                          Delete
                        </a>
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

  <script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"
  ></script>
</body>
</html>
