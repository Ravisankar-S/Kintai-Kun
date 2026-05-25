import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content", "icon"]

  connect() {
    // Start the 6-second timer to collapse the card automatically
    this.timeoutId = setTimeout(() => {
      this.collapse()
    }, 6000)
  }

  collapse() {
    this.contentTarget.classList.add("hidden")
    this.iconTarget.classList.remove("hidden")
    this.element.classList.remove("w-64", "p-4")
    this.element.classList.add("w-12", "h-12", "p-0", "flex", "items-center", "justify-center", "cursor-pointer")
  }

  expand() {
    // If it's already expanded, do nothing
    if (!this.contentTarget.classList.contains("hidden")) return

    this.contentTarget.classList.remove("hidden")
    this.iconTarget.classList.add("hidden")
    this.element.classList.add("w-64", "p-4")
    this.element.classList.remove("w-12", "h-12", "p-0", "flex", "items-center", "justify-center", "cursor-pointer")

    // Clear any existing timeout and reset it
    clearTimeout(this.timeoutId)
    this.timeoutId = setTimeout(() => {
      this.collapse()
    }, 6000)
  }
}
