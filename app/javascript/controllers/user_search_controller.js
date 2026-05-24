import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="user-search"
export default class extends Controller {
  static targets = ["input"]
  static values = { url: String }

  connect() {
    this.timeout = null
  }

  disconnect() {
    if (this.timeout) {
      clearTimeout(this.timeout)
    }
  }

  search() {
    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => {
      const query = this.inputTarget.value
      fetch(`${this.urlValue}?query=${encodeURIComponent(query)}`, {
        headers: {
          "Accept": "text/vnd.turbo-stream.html",
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
        }
      })
      .then(r => r.text())
      .then(html => Turbo.renderStreamMessage(html))
    }, 300)
  }
}
