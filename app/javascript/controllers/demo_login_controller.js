import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["email", "password", "form"]

  fill(event) {
    event.preventDefault()
    const email = event.currentTarget.dataset.email
    const password = "password" // Hardcoded since demo accounts use 'password'

    this.emailTarget.value = email
    this.passwordTarget.value = password
    
    // Slight delay before submitting to show the fields filling up
    setTimeout(() => {
      this.formTarget.requestSubmit()
    }, 200)
  }
}
