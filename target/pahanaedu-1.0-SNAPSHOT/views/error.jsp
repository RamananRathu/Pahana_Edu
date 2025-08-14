<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Error - Pahana Edu</title>
  <link 
    href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" 
    rel="stylesheet"
  >
</head>
<body class="bg-light">
  <div class="container">
    <div class="row justify-content-center">
      <div class="col-md-8">
        <div class="card mt-5">
          <div class="card-body">
            <h1 class="display-1 text-danger text-center">Oops!</h1>
            <h3 class="text-center">Something went wrong</h3>
            <p class="text-muted text-center">
              We’re sorry, but an error occurred while processing your request.
            </p>

            <!-- ▼ Exception details ▼ -->
            <c:if test="${not empty exception}">
              <hr/>
              <h5>Error Details:</h5>
              <p><strong>Exception Type:</strong> <%= exception.getClass().getName() %></p>
              <p><strong>Message:</strong> <%= exception.getMessage() %></p>
              <pre style="max-height:300px;overflow:auto;background:#f8f9fa;padding:10px;border:1px solid #ddd;">
<%  
  // print full stack trace 
  java.io.StringWriter sw = new java.io.StringWriter();
  java.io.PrintWriter pw = new java.io.PrintWriter(sw);
  exception.printStackTrace(pw);
  out.print(sw.toString());
%>
              </pre>
            </c:if>
            <!-- ▲ End exception details ▲ -->

            <div class="mt-4 text-center">
              <a href="${pageContext.request.contextPath}/dashboard" 
                 class="btn btn-primary me-2">Go to Dashboard</a>
              <a href="${pageContext.request.contextPath}/auth/login" 
                 class="btn btn-outline-secondary">Login</a>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <script 
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"
  ></script>
</body>
</html>
