<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Items – Pahana Edu</title>
  <link
    href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css"
    rel="stylesheet"
  >
</head>
<body>

  <div class="container mt-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
      <h2>Items</h2>
      <a href="${pageContext.request.contextPath}/items?action=add"
         class="btn btn-primary">Add New Item</a>
    </div>

    <c:if test="${not empty error}">
      <div class="alert alert-danger">${error}</div>
    </c:if>

    <c:if test="${empty items}">
      <p>No items found.</p>
    </c:if>
    <c:if test="${not empty items}">
      <table class="table table-striped">
        <thead>
          <tr>
            <th>Code</th>
            <th>Title</th>
            <th>Price</th>
            <th>Stock</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="item" items="${items}">
            <tr>
              <td>${item.itemCode}</td>
              <td>${item.title}</td>
              <td>$${item.price}</td>
              <td>${item.stockQuantity}</td>
              <td>
                <a href="${pageContext.request.contextPath}/items?action=edit&amp;id=${item.id}"
                   class="btn btn-sm btn-outline-primary">Edit</a>
                <a href="${pageContext.request.contextPath}/items?action=delete&amp;id=${item.id}"
                   class="btn btn-sm btn-outline-danger"
                   onclick="return confirm('Delete this item?');">Delete</a>
              </td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </c:if>
  </div>
</body>
</html>
