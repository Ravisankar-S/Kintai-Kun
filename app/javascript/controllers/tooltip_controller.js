// Tooltip Stimulus Controller
// Shows a floating tooltip above hovered memo cells after a 300ms delay.

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { content: String }

  connect() {
    this._timer    = null
    this._tooltip  = null
    this._enter    = this._handleEnter.bind(this)
    this._leave    = this._handleLeave.bind(this)
    this.element.addEventListener("mouseenter", this._enter)
    this.element.addEventListener("mouseleave", this._leave)
  }

  disconnect() {
    this.element.removeEventListener("mouseenter", this._enter)
    this.element.removeEventListener("mouseleave", this._leave)
    this._clear()
  }

  _handleEnter() {
    if (!this.contentValue) return

    this._timer = setTimeout(() => {
      this._show()
    }, 300)
  }

  _handleLeave() {
    this._clear()
  }

  _show() {
    const tip = document.createElement("div")
    tip.textContent = this.contentValue
    tip.style.cssText = `
      position: fixed;
      z-index: 9999;
      background: #1A1A18;
      color: #fff;
      font-size: 12px;
      font-family: 'Geist', 'Inter', sans-serif;
      padding: 6px 12px;
      border-radius: 8px;
      white-space: nowrap;
      pointer-events: none;
      opacity: 0;
      transition: opacity 100ms ease;
    `

    document.body.appendChild(tip)
    this._tooltip = tip

    // Position above the element
    const rect = this.element.getBoundingClientRect()
    const tipRect = tip.getBoundingClientRect()
    const top  = rect.top - tipRect.height - 8 + window.scrollY
    const left = rect.left + rect.width / 2 - tipRect.width / 2 + window.scrollX

    tip.style.top  = `${top}px`
    tip.style.left = `${left}px`

    // Trigger fade-in
    requestAnimationFrame(() => {
      requestAnimationFrame(() => { tip.style.opacity = "1" })
    })
  }

  _clear() {
    clearTimeout(this._timer)
    this._timer = null
    if (this._tooltip) {
      this._tooltip.remove()
      this._tooltip = null
    }
  }
}
