import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    start: String,
    breakMinutes: Number,
    onBreak: Boolean
  }
  static targets = ["display", "indicator"]

  connect() {
    this.startTime = new Date(this.startValue).getTime()
    this.breakMillis = (this.breakMinutesValue || 0) * 60 * 1000
    
    this.updateTimer()
    if (!this.onBreakValue) {
      this.timerInterval = setInterval(() => {
        this.updateTimer()
      }, 1000)
    } else {
      // If on break, blink the timer
      this.displayTarget.classList.add("animate-pulse", "text-amber-500")
      if (this.hasIndicatorTarget) {
        this.indicatorTarget.classList.replace("bg-emerald-500", "bg-amber-500")
      }
    }
  }

  disconnect() {
    if (this.timerInterval) clearInterval(this.timerInterval)
  }

  updateTimer() {
    const now = new Date().getTime()
    // Total elapsed time since clock in, minus the breaks already taken
    let elapsed = now - this.startTime - this.breakMillis
    
    if (elapsed < 0) elapsed = 0

    const hours = Math.floor(elapsed / (1000 * 60 * 60))
    const minutes = Math.floor((elapsed % (1000 * 60 * 60)) / (1000 * 60))
    const seconds = Math.floor((elapsed % (1000 * 60)) / 1000)

    const formatted = [
      hours.toString().padStart(2, '0'),
      minutes.toString().padStart(2, '0'),
      seconds.toString().padStart(2, '0')
    ].join(':')

    this.displayTarget.textContent = formatted
  }
}
