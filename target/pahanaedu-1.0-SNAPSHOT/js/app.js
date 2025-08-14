// Pahana Edu JavaScript functionality

// Import Bootstrap
var bootstrap = window.bootstrap

document.addEventListener("DOMContentLoaded", () => {
  // Initialize tooltips
  var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
  var tooltipList = tooltipTriggerList.map((tooltipTriggerEl) => new bootstrap.Tooltip(tooltipTriggerEl))

  // Form validation
  var forms = document.querySelectorAll(".needs-validation")
  Array.prototype.slice.call(forms).forEach((form) => {
    form.addEventListener(
      "submit",
      (event) => {
        if (!form.checkValidity()) {
          event.preventDefault()
          event.stopPropagation()
        }
        form.classList.add("was-validated")
      },
      false,
    )
  })

  // Auto-hide alerts after 5 seconds
  var alerts = document.querySelectorAll(".alert:not(.alert-permanent)")
  alerts.forEach((alert) => {
    setTimeout(() => {
      var bsAlert = new bootstrap.Alert(alert)
      bsAlert.close()
    }, 5000)
  })

  // Confirm delete actions
  var deleteLinks = document.querySelectorAll('a[href*="delete"]')
  deleteLinks.forEach((link) => {
    link.addEventListener("click", (e) => {
      if (!confirm("Are you sure you want to delete this item?")) {
        e.preventDefault()
      }
    })
  })

  // Format currency inputs
  var currencyInputs = document.querySelectorAll('input[type="number"][step="0.01"]')
  currencyInputs.forEach((input) => {
    input.addEventListener("blur", function () {
      if (this.value) {
        this.value = Number.parseFloat(this.value).toFixed(2)
      }
    })
  })

  // Auto-generate account numbers
  var accountNumberInput = document.getElementById("accountNumber")
  if (accountNumberInput && !accountNumberInput.value && !accountNumberInput.readOnly) {
    accountNumberInput.value = "ACC" + Date.now().toString().slice(-6)
  }

  // Auto-generate item IDs
  var itemIdInput = document.getElementById("id")
  if (itemIdInput && !itemIdInput.value && !itemIdInput.readOnly) {
    itemIdInput.value = "B" + Date.now().toString().slice(-3)
  }
})

// Utility functions
function formatCurrency(amount) {
  return new Intl.NumberFormat("en-US", {
    style: "currency",
    currency: "USD",
  }).format(amount)
}

function showAlert(message, type = "info") {
  var alertDiv = document.createElement("div")
  alertDiv.className = `alert alert-${type} alert-dismissible fade show`
  alertDiv.innerHTML = `
        ${message}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    `

  var container = document.querySelector(".container")
  if (container) {
    container.insertBefore(alertDiv, container.firstChild)

    // Auto-hide after 5 seconds
    setTimeout(() => {
      var bsAlert = new bootstrap.Alert(alertDiv)
      bsAlert.close()
    }, 5000)
  }
}

// Print functionality
function printBill() {
  window.print()
}

// Session timeout warning
var sessionTimeout = 30 * 60 * 1000 // 30 minutes
var warningTime = 5 * 60 * 1000 // 5 minutes before timeout

setTimeout(() => {
  if (confirm("Your session will expire in 5 minutes. Do you want to continue?")) {
    // Refresh the page to extend session
    window.location.reload()
  }
}, sessionTimeout - warningTime)
