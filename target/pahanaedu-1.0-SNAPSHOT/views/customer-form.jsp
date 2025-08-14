<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport"
        content="width=device-width, initial-scale=1.0">
  <title>
    <c:out value="${isEdit ? 'Edit' : 'Add'}"/> Customer
  </title>
  <link
    href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css"
    rel="stylesheet"
  >
  <link
    href="${pageContext.request.contextPath}/css/style.css"
    rel="stylesheet"
  >
</head>
<body>
  <%@ include file="includes/navbar.jsp" %>

  <div class="container mt-4">
    <div class="row justify-content-center">
      <div class="col-md-10">
        <div class="card shadow-sm">
          <div class="card-header bg-white">
            <h3 class="mb-0">
              <c:out value="${isEdit ? 'Edit' : 'Add New'}"/> Customer
            </h3>
          </div>
          <div class="card-body">
            <c:if test="${not empty error}">
              <div class="alert alert-danger">
                <c:out value="${error}"/>
              </div>
            </c:if>

            <form method="post"
                  action="${pageContext.request.contextPath}/customers"
                  class="needs-validation" novalidate>

              <!-- hidden action -->
              <input type="hidden"
                     name="action"
                     value="${isEdit ? 'update' : 'add'}"/>

              <!-- if updating, include ID -->
              <c:if test="${isEdit}">
                <input type="hidden"
                       name="id"
                       value="${customer.id}"/>
              </c:if>

              <div class="row g-3">
                <div class="col-md-6">
                  <label for="accountNumber"
                         class="form-label">Account Number *</label>
                  <input type="text"
                         class="form-control"
                         id="accountNumber"
                         name="accountNumber"
                         value="${customer.accountNumber}"
                         ${isEdit ? "readonly" : ""}
                         required>
                  <div class="invalid-feedback">
                    Please provide an account number.
                  </div>
                </div>

                <div class="col-md-6">
                  <label for="email"
                         class="form-label">Email</label>
                  <input type="email"
                         class="form-control"
                         id="email"
                         name="email"
                         value="${customer.email}">
                </div>

                <div class="col-md-6">
                  <label for="firstName"
                         class="form-label">First Name *</label>
                  <input type="text"
                         class="form-control"
                         id="firstName"
                         name="firstName"
                         value="${customer.firstName}"
                         required>
                  <div class="invalid-feedback">
                    Please provide a first name.
                  </div>
                </div>

                <div class="col-md-6">
                  <label for="lastName"
                         class="form-label">Last Name *</label>
                  <input type="text"
                         class="form-control"
                         id="lastName"
                         name="lastName"
                         value="${customer.lastName}"
                         required>
                  <div class="invalid-feedback">
                    Please provide a last name.
                  </div>
                </div>

                <div class="col-md-6">
                  <label for="phone"
                         class="form-label">Phone</label>
                  <input type="tel"
                         class="form-control"
                         id="phone"
                         name="phone"
                         value="${customer.phone}">
                </div>

                <div class="col-md-6">
                  <label for="dateOfBirth"
                         class="form-label">Date of Birth</label>
                  <input type="date"
                         class="form-control"
                         id="dateOfBirth"
                         name="dateOfBirth"
                         value="<fmt:formatDate value='${customer.dateOfBirth}' pattern='yyyy-MM-dd'/>">
                </div>

                <div class="col-12">
                  <label for="addressLine1"
                         class="form-label">Address Line 1</label>
                  <input type="text"
                         class="form-control"
                         id="addressLine1"
                         name="addressLine1"
                         value="${customer.addressLine1}">
                </div>

                <div class="col-12">
                  <label for="addressLine2"
                         class="form-label">Address Line 2</label>
                  <input type="text"
                         class="form-control"
                         id="addressLine2"
                         name="addressLine2"
                         value="${customer.addressLine2}">
                </div>

                <div class="col-md-4">
                  <label for="city"
                         class="form-label">City</label>
                  <input type="text"
                         class="form-control"
                         id="city"
                         name="city"
                         value="${customer.city}">
                </div>

                <div class="col-md-4">
                  <label for="state"
                         class="form-label">State</label>
                  <input type="text"
                         class="form-control"
                         id="state"
                         name="state"
                         value="${customer.state}">
                </div>

                <div class="col-md-4">
                  <label for="postalCode"
                         class="form-label">
                    Postal Code
                  </label>
                  <input type="text"
                         class="form-control"
                         id="postalCode"
                         name="postalCode"
                         value="${customer.postalCode}">
                </div>

                <div class="col-md-4">
                  <label for="country"
                         class="form-label">Country</label>
                  <input type="text"
                         class="form-control"
                         id="country"
                         name="country"
                         value="${customer.country != null ? customer.country : 'USA'}">
                </div>

                <div class="col-md-4">
                  <label for="gender"
                         class="form-label">Gender</label>
                  <select class="form-select"
                          id="gender"
                          name="gender">
                    <option value="">Select...</option>
                    <option value="male"
                      <c:if test="${customer.gender=='male'}">selected</c:if>>
                      Male
                    </option>
                    <option value="female"
                      <c:if test="${customer.gender=='female'}">selected</c:if>>
                      Female
                    </option>
                    <option value="other"
                      <c:if test="${customer.gender=='other'}">selected</c:if>>
                      Other
                    </option>
                  </select>
                </div>

                <div class="col-md-4">
                  <label for="unitsConsumed"
                         class="form-label">
                    Units Consumed
                  </label>
                  <input type="number"
                         class="form-control"
                         id="unitsConsumed"
                         name="unitsConsumed"
                         min="0"
                         value="${customer.unitsConsumed}">
                </div>

                <div class="col-md-6">
                  <label for="creditLimit"
                         class="form-label">
                    Credit Limit
                  </label>
                  <input type="number"
                         class="form-control"
                         id="creditLimit"
                         name="creditLimit"
                         step="0.01"
                         min="0"
                         value="${customer.creditLimit}">
                </div>
              </div>

              <div class="mt-4 d-flex justify-content-between">
                <a href="${pageContext.request.contextPath}/customers"
                   class="btn btn-secondary">
                  Cancel
                </a>
                <button type="submit"
                        class="btn btn-primary">
                  <c:out value="${isEdit ? 'Update' : 'Add'}"/> Customer
                </button>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>
  </div>

  <script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"
  ></script>
  <script src="${pageContext.request.contextPath}/js/app.js"></script>
</body>
</html>
