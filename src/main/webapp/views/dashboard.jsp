<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Dashboard – Pahana Edu</title>

  <!-- Bootstrap 5 CSS -->
  <link 
    href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" 
    rel="stylesheet"
  >

  <!-- Bootstrap Icons -->
  <link 
    href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.9.1/font/bootstrap-icons.css" 
    rel="stylesheet"
  >

  <!-- Your custom styles -->
  <link 
    href="${pageContext.request.contextPath}/css/style.css" 
    rel="stylesheet"
  >
</head>
<body>
  <!-- Top navbar -->
  <jsp:include page="/views/includes/navbar.jsp"/>

  <div class="container my-5">
    <h1 class="mb-4">Welcome, <c:out value="${sessionScope.user.username}"/>!</h1>

    <!-- Metrics cards -->
    <div class="row g-4 mb-5">
      <!-- Customers -->
      <div class="col-6 col-md-3">
        <div class="card text-white bg-primary h-100">
          <div class="card-body text-center">
            <i class="bi bi-people-fill display-4"></i>
            <h5 class="card-title mt-2">Customers</h5>
            <p class="display-5 mb-0">${customerCount}</p>
          </div>
          <div class="card-footer text-center">
            <a href="${pageContext.request.contextPath}/customers" 
               class="text-white text-decoration-none">
              Manage &raquo;
            </a>
          </div>
        </div>
      </div>

      <!-- Items -->
      <div class="col-6 col-md-3">
        <div class="card text-white bg-success h-100">
          <div class="card-body text-center">
            <i class="bi bi-box-seam display-4"></i>
            <h5 class="card-title mt-2">Items</h5>
            <p class="display-5 mb-0">${itemCount}</p>
          </div>
          <div class="card-footer text-center">
            <a href="${pageContext.request.contextPath}/items" 
               class="text-white text-decoration-none">
              Manage &raquo;
            </a>
          </div>
        </div>
      </div>

      <!-- Bills (placeholder count) -->
      <div class="col-6 col-md-3">
        <div class="card text-white bg-warning h-100">
          <div class="card-body text-center">
            <i class="bi bi-receipt display-4"></i>
            <h5 class="card-title mt-2">Bills</h5>
            <p class="display-5 mb-0">0</p>
          </div>
          <div class="card-footer text-center">
            <a href="${pageContext.request.contextPath}/billing/generate" 
               class="text-white text-decoration-none">
              Generate &raquo;
            </a>
          </div>
        </div>
      </div>

      <!-- Active Sessions -->
      <div class="col-6 col-md-3">
        <div class="card text-white bg-info h-100">
          <div class="card-body text-center">
            <i class="bi bi-person-check display-4"></i>
            <h5 class="card-title mt-2">Sessions</h5>
            <p class="display-5 mb-0">1</p>
          </div>
          <div class="card-footer text-center">
            <a href="#" class="text-white text-decoration-none">
              View &raquo;
            </a>
          </div>
        </div>
      </div>
    </div>

    <!-- Quick Links Row -->
    <div class="row">
      <div class="col-md-4 mb-4">
        <div class="card h-100 border-primary">
          <div class="card-body">
            <h5 class="card-title">Customer Management</h5>
            <p class="card-text">
              Create, edit, and remove customer accounts.
            </p>
            <a href="${pageContext.request.contextPath}/customers" 
               class="btn btn-outline-primary">
              Go &raquo;
            </a>
          </div>
        </div>
      </div>

      <div class="col-md-4 mb-4">
        <div class="card h-100 border-success">
          <div class="card-body">
            <h5 class="card-title">Item Inventory</h5>
            <p class="card-text">
              Browse stock, prices, and descriptions.
            </p>
            <a href="${pageContext.request.contextPath}/items" 
               class="btn btn-outline-success">
              Go &raquo;
            </a>
          </div>
        </div>
      </div>

      <div class="col-md-4 mb-4">
        <div class="card h-100 border-warning">
          <div class="card-body">
            <h5 class="card-title">Billing</h5>
            <p class="card-text">
              Generate invoices and track payments.
            </p>
            <a href="${pageContext.request.contextPath}/billing/generate" 
               class="btn btn-outline-warning">
              Go &raquo;
            </a>
          </div>
        </div>
      </div>
    </div>
  </div>

  <!-- Bootstrap JS bundle -->
  <script 
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"
  ></script>
</body>
</html>
