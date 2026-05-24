// Month Filter Stimulus Controller
// Drives the custom month dropdown on the work log history page.

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["trigger", "dropdown"]

  connect() {
    // Bind click-outside handler so we can remove it on disconnect
    this._outsideHandler = this._handleOutsideClick.bind(this)
    document.addEventListener("click", this._outsideHandler)

    // Ensure dropdown starts closed
    this._close()
  }

  disconnect() {
    document.removeEventListener("click", this._outsideHandler)
  }

  toggle(event) {
    event.stopPropagation() // prevent outsideHandler from firing immediately

    const isHidden = this.dropdownTarget.classList.contains("hidden")
    if (isHidden) {
      this._open()
    } else {
      this._close()
    }
  }

  _open() {
    const dd = this.dropdownTarget
    dd.classList.remove("hidden")
    // Force reflow so transition plays
    dd.offsetHeight
    dd.classList.remove("opacity-0", "-translate-y-1")
    dd.classList.add("opacity-100", "translate-y-0")
    this.triggerTarget.setAttribute("aria-expanded", "true")
  }

  _close() {
    const dd = this.dropdownTarget
    dd.classList.add("opacity-0", "-translate-y-1")
    dd.classList.remove("opacity-100", "translate-y-0")
    this.triggerTarget.setAttribute("aria-expanded", "false")
    // Hide after transition completes
    setTimeout(() => {
      if (dd.classList.contains("opacity-0")) {
        dd.classList.add("hidden")
      }
    }, 150)
  }

  _handleOutsideClick(event) {
    if (!this.element.contains(event.target)) {
      this._close()
    }
  }
}
