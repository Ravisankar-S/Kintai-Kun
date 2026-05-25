import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["latitude", "longitude"]

  fetchAndSubmit(event) {
    // If we've already fetched the location, just let the form submit normally
    if (this.element.dataset.locationFetched === "true") {
      return
    }

    event.preventDefault()

    if (!navigator.geolocation) {
      console.warn("Geolocation is not supported by your browser.")
      this.submitForm()
      return
    }

    // Show a loading state on the submit button if needed
    const submitBtn = this.element.querySelector('input[type="submit"]')
    if (submitBtn) {
      this.originalBtnText = submitBtn.value
      submitBtn.value = "Locating..."
      submitBtn.disabled = true
    }

    navigator.geolocation.getCurrentPosition(
      (position) => {
        this.latitudeTarget.value = position.coords.latitude
        this.longitudeTarget.value = position.coords.longitude
        this.submitForm()
      },
      (error) => {
        console.warn("Geolocation error:", error.message)
        // Submit anyway so we don't block clocking in
        this.submitForm()
      },
      {
        enableHighAccuracy: true,
        timeout: 5000,
        maximumAge: 0
      }
    )
  }

  submitForm() {
    this.element.dataset.locationFetched = "true"
    
    // Restore button state
    const submitBtn = this.element.querySelector('input[type="submit"]')
    if (submitBtn) {
      submitBtn.value = this.originalBtnText || "Submit"
      submitBtn.disabled = false
    }

    this.element.requestSubmit()
  }
}
