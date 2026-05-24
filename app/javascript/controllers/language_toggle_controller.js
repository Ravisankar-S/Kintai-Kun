import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "checkbox"]

  toggle() {
    // When the checkbox changes, we submit the form to update the locale
    this.formTarget.requestSubmit()
  }
}
