<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Bill Invoice – Pahana Edu</title>
  <link
    href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css"
    rel="stylesheet"
  >
  <style>
    @media print { .no-print { display: none !important; } }
  </style>
</head>
<body>
  <jsp:include page="/views/includes/navbar.jsp"/>

  <div class="container mt-4">
    <div class="card mx-auto" style="max-width: 700px;">
      <div class="card-header text-center">
        <h2>Pahana Edu</h2>
        <h4>Bill Invoice</h4>
      </div>
      <div class="card-body">

        <!-- Bill & Customer info -->
        <div class="row mb-4">
          <div class="col-md-6">
            <h5>Bill Details</h5>
            <p><strong>Bill Number:</strong>
              <c:out value="${bill.billNumber}"/>
            </p>
            <p><strong>Bill Date:</strong>
              <fmt:formatDate
                value="${bill.billDate}"
                pattern="dd/MM/yyyy HH:mm:ss"
              />
            </p>
            <p><strong>Due Date:</strong>
              <fmt:formatDate
                value="${bill.dueDate}"
                pattern="dd/MM/yyyy"
              />
            </p>
          </div>
          <div class="col-md-6">
            <h5>Customer</h5>
            <p>
              <strong>Account #:</strong>
              <c:out value="${bill.customerAccountNumber}"/>
            </p>
            <p>
              <strong>Name:</strong>
              <c:out value="${bill.customerName}"/>
            </p>
          </div>
        </div>

        <!-- Line Items -->
        <div class="table-responsive">
          <table class="table table-bordered">
            <thead class="table-dark">
              <tr>
                <th>Description</th>
                <th class="text-end">Qty</th>
                <th class="text-end">Unit Price</th>
                <th class="text-end">Line Total</th>
              </tr>
            </thead>
            <tbody>
              <c:forEach var="item" items="${bill.billItems}">
                <tr>
                  <td><c:out value="${item.description}"/></td>
                  <td class="text-end"><c:out value="${item.quantity}"/></td>
                  <td class="text-end">
                    $<fmt:formatNumber
                      value="${item.unitPrice}"
                      pattern="#,##0.00"
                    />
                  </td>
                  <td class="text-end">
                    $<fmt:formatNumber
                      value="${item.lineTotal}"
                      pattern="#,##0.00"
                    />
                  </td>
                </tr>
              </c:forEach>
            </tbody>
            <tfoot class="table-active">
              <tr>
                <th colspan="3" class="text-end">Subtotal:</th>
                <th class="text-end">
                  $<fmt:formatNumber
                    value="${bill.subtotal}"
                    pattern="#,##0.00"
                  />
                </th>
              </tr>
              <tr>
                <th colspan="3" class="text-end">
                  Tax (${bill.taxRate}%):
                </th>
                <th class="text-end">
                  $<fmt:formatNumber
                    value="${bill.taxAmount}"
                    pattern="#,##0.00"
                  />
                </th>
              </tr>
              <tr>
                <th colspan="3" class="text-end">Discount:</th>
                <th class="text-end">
                  $<fmt:formatNumber
                    value="${bill.discountAmount}"
                    pattern="#,##0.00"
                  />
                </th>
              </tr>
              <tr>
                <th colspan="3" class="text-end">Total:</th>
                <th class="text-end">
                  $<fmt:formatNumber
                    value="${bill.totalAmount}"
                    pattern="#,##0.00"
                  />
                </th>
              </tr>
              <tr>
                <th colspan="3" class="text-end">Paid:</th>
                <th class="text-end">
                  $<fmt:formatNumber
                    value="${bill.paidAmount}"
                    pattern="#,##0.00"
                  />
                </th>
              </tr>
              <tr>
                <th colspan="3" class="text-end">Balance:</th>
                <th class="text-end">
                  $<fmt:formatNumber
                    value="${bill.balanceAmount}"
                    pattern="#,##0.00"
                  />
                </th>
              </tr>
            </tfoot>
          </table>
        </div>

        <div class="text-center mt-3">
          <p class="text-muted">Thank you for using Pahana Edu!</p>
        </div>

        <div class="d-flex justify-content-between no-print">
          <a href="${pageContext.request.contextPath}/billing/generate"
             class="btn btn-secondary">
            New Bill
          </a>
          <button onclick="window.print()" class="btn btn-primary">
            Print
          </button>
        </div>

      </div>
    </div>
  </div>
</body>
</html>
