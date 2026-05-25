import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log("Tour connected!")
    // Only run the tour once per device (using localStorage)
    if (!localStorage.getItem("kintaiTourCompleted")) {
      setTimeout(() => {
        this.startTour()
      }, 500)
    }
  }

  startTour() {
    this.overlay = document.createElement("div")
    this.overlay.className = "fixed inset-0 bg-slate-900/80 z-[45] backdrop-blur-sm transition-opacity duration-300 opacity-0"
    document.body.appendChild(this.overlay)

    void this.overlay.offsetWidth
    this.overlay.classList.remove("opacity-0")
    this.overlay.classList.add("opacity-100")

    this.showStep1()
  }

  showStep1() {
    this.currentStep = 1
    const target = document.querySelector('[data-tour-step="1"]')
    if (!target) return

    this.highlightTarget(target)

    this.tooltip = document.createElement("div")
    this.tooltip.className = "fixed z-[60] bg-white rounded-xl shadow-2xl p-5 w-[280px] animate-[popIn_0.3s_ease-out_forwards]"
    this.tooltip.innerHTML = `
      <h4 class="text-[16px] font-semibold text-slate-900 mb-1" style="font-family: 'DM Serif Display', serif;">Language Selector</h4>
      <p class="text-[13px] text-slate-600 mb-4" style="font-family: 'Geist', sans-serif;">Toggle the entire application between English and Japanese instantly.</p>
      <div class="flex justify-end">
        <button id="tour-next-btn" class="bg-emerald-700 hover:bg-emerald-800 text-white px-4 py-2 rounded-lg text-sm font-medium transition-colors cursor-pointer">Next</button>
      </div>
    `
    document.body.appendChild(this.tooltip)

    this.positionTooltip(target)

    document.getElementById("tour-next-btn").addEventListener("click", () => {
      this.unhighlightTarget(target)
      this.tooltip.remove()
      this.showStep2()
    })
  }

  showStep2() {
    this.currentStep = 2
    const target = document.querySelector('[data-tour-step="2"]')
    if (!target) return

    this.highlightTarget(target)

    this.tooltip = document.createElement("div")
    this.tooltip.className = "fixed z-[60] bg-white rounded-xl shadow-2xl p-5 w-[280px] animate-[popIn_0.3s_ease-out_forwards]"
    this.tooltip.innerHTML = `
      <h4 class="text-[16px] font-semibold text-slate-900 mb-1" style="font-family: 'DM Serif Display', serif;">Timezone Selector</h4>
      <p class="text-[13px] text-slate-600 mb-4" style="font-family: 'Geist', sans-serif;">Switch between IST (India) and JST (Japan) to view logs in your local time.</p>
      <div class="flex justify-end">
        <button id="tour-next2-btn" class="bg-emerald-700 hover:bg-emerald-800 text-white px-4 py-2 rounded-lg text-sm font-medium transition-colors cursor-pointer">Next</button>
      </div>
    `
    document.body.appendChild(this.tooltip)

    this.positionTooltip(target)

    document.getElementById("tour-next2-btn").addEventListener("click", () => {
      this.unhighlightTarget(target)
      this.tooltip.remove()
      this.showStep3()
    })
  }

  showStep3() {
    this.currentStep = 3

    this.tooltip = document.createElement("div")
    this.tooltip.className = "fixed z-[60] bg-white rounded-xl shadow-2xl p-6 w-[320px] animate-[popIn_0.3s_ease-out_forwards]"
    // Center the tooltip
    this.tooltip.style.top = "50%"
    this.tooltip.style.left = "50%"
    this.tooltip.style.transform = "translate(-50%, -50%)"
    
    this.tooltip.innerHTML = `
      <h4 class="text-[18px] font-semibold text-slate-900 mb-2" style="font-family: 'DM Serif Display', serif;">Tour Complete</h4>
      <p class="text-[14px] text-slate-600 mb-6" style="font-family: 'Geist', sans-serif;">Preset credentials available for demo. Proceed to next pages.</p>
      <div class="flex justify-center">
        <button id="tour-done-btn" class="w-full bg-emerald-700 hover:bg-emerald-800 text-white px-6 py-2.5 rounded-lg text-sm font-medium transition-colors cursor-pointer">Done</button>
      </div>
    `
    document.body.appendChild(this.tooltip)

    document.getElementById("tour-done-btn").addEventListener("click", () => {
      this.endTour()
    })
  }

  highlightTarget(target) {
    target.dataset.originalPosition = target.style.position || getComputedStyle(target).position
    target.dataset.originalZIndex = target.style.zIndex || getComputedStyle(target).zIndex

    target.classList.add("relative", "z-50")
    
    target.style.boxShadow = "0 0 0 4px rgba(255, 255, 255, 1), 0 0 20px rgba(16, 185, 129, 0.4)"
    target.style.borderRadius = "8px"
    target.style.transition = "all 0.3s ease"
    target.style.backgroundColor = "#ffffff"
  }

  unhighlightTarget(target) {
    target.classList.remove("relative", "z-50")
    target.style.position = target.dataset.originalPosition
    target.style.zIndex = target.dataset.originalZIndex
    target.style.boxShadow = ""
    target.style.borderRadius = ""
    target.style.backgroundColor = ""
  }

  positionTooltip(target) {
    const rect = target.getBoundingClientRect()
    let top = rect.bottom + 16
    let left = rect.left + (rect.width / 2) - 140

    if (left + 280 > window.innerWidth - 20) {
      left = window.innerWidth - 300
    }

    this.tooltip.style.top = `${top}px`
    this.tooltip.style.left = `${left}px`
  }

  endTour() {
    if (this.tooltip) this.tooltip.remove()
    
    this.overlay.classList.remove("opacity-100")
    this.overlay.classList.add("opacity-0")
    
    setTimeout(() => {
      if (this.overlay) this.overlay.remove()
    }, 300)

    localStorage.setItem("kintaiTourCompleted", "true")
  }
}
