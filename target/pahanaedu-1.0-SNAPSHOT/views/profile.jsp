<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" isErrorPage="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>My Profile – Pahana Edu</title>
  <link 
    href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" 
    rel="stylesheet"
  >
</head>
<body>
  <%@ include file="includes/navbar.jsp" %>

  <div class="container my-5">
    <h2>My Profile</h2>

    <c:if test="${not empty success}">
      <div class="alert alert-success">${success}</div>
    </c:if>
    <c:if test="${not empty error}">
      <div class="alert alert-danger">${error}</div>
    </c:if>

    <form action="${pageContext.request.contextPath}/profile" method="post" class="mt-4">
      <div class="mb-3">
        <label class="form-label">Username</label>
        <input type="text" name="username" class="form-control"
               value="${user.username}" required>
      </div>
      <div class="mb-3">
        <label class="form-label">Full Name</label>
        <input type="text" name="fullName" class="form-control"
               value="${user.fullName}" required>
      </div>
      <div class="mb-3">
        <label class="form-label">Email</label>
        <input type="email" name="email" class="form-control"
               value="${user.email}" required>
      </div>
      <div class="mb-3">
        <label class="form-label">New Password <small>(leave blank to keep current)</small></label>
        <input type="password" name="password" class="form-control">
      </div>
      <button type="submit" class="btn btn-primary">Save Changes</button>
      <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-secondary ms-2">Cancel</a>
    </form>
  </div>

  <script 
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"
  ></script>
</body>
</html>
