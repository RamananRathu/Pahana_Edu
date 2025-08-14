<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title><c:out value="${isEdit ? 'Edit' : 'Add New'}"/> Item</title>
  <link
    href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css"
    rel="stylesheet"
  >
</head>
<body>

  <div class="container mt-4">
    <div class="card">
      <div class="card-header">
        <h3><c:out value="${isEdit ? 'Edit Item' : 'Add New Item'}"/></h3>
      </div>
      <div class="card-body">
        <c:if test="${not empty error}">
          <div class="alert alert-danger">${error}</div>
        </c:if>
        <form method="post"
              action="${pageContext.request.contextPath}/items">
          <!-- hidden action field -->
          <input type="hidden" name="action"
                 value="${isEdit ? 'update' : 'add'}"/>
          <c:if test="${isEdit}">
            <input type="hidden" name="id" value="${item.id}"/>
          </c:if>

          <div class="mb-3">
            <label for="itemCode" class="form-label">Item Code</label>
            <input type="text" class="form-control" id="itemCode"
                   name="itemCode"
                   value="${item.itemCode}"
                   ${isEdit ? "readonly" : ""} required>
          </div>

          <div class="mb-3">
            <label for="title" class="form-label">Title</label>
            <input type="text" class="form-control" id="title"
                   name="title"
                   value="${item.title}" required>
          </div>

          <div class="mb-3">
            <label for="price" class="form-label">Price</label>
            <input type="number" class="form-control" id="price"
                   name="price" step="0.01" min="0"
                   value="${item.price}" required>
          </div>

          <div class="mb-3">
            <label for="stock" class="form-label">Stock Quantity</label>
            <input type="number" class="form-control" id="stock"
                   name="stock" min="0"
                   value="${item.stockQuantity}" required>
          </div>

          <div class="d-flex justify-content-between">
            <a href="${pageContext.request.contextPath}/items"
               class="btn btn-secondary">Cancel</a>
            <button type="submit"
                    class="btn btn-primary">
              <c:out value="${isEdit ? 'Update' : 'Add'}"/> Item
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>
</body>
</html>
