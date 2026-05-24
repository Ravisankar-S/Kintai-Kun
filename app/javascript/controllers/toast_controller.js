import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["notification"]

  connect() {
    this.notificationTargets.forEach((el) => {
      // Small delay to allow CSS transitions to trigger
      setTimeout(() => {
        el.classList.remove("translate-x-full", "opacity-0")
        el.classList.add("translate-x-0", "opacity-100")
      }, 50)

      // Auto dismiss after 4 seconds
      setTimeout(() => {
        this.closeElement(el)
      }, 4000)
    })
  }

  close(event) {
    const el = event.currentTarget.closest('[data-toast-target="notification"]')
    if (el) {
      this.closeElement(el)
    }
  }

  closeElement(el) {
    el.classList.remove("translate-x-0", "opacity-100")
    el.classList.add("translate-x-full", "opacity-0")
    setTimeout(() => {
      el.remove()
    }, 300) // matches transition duration
  }
}
