import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tab", "panel"]

  connect() {
    this.switch({ currentTarget: this.tabTargets.find(t => t.dataset.section === "personal") })
  }

  switch(event) {
    const section = event.currentTarget.dataset.section

    // Update tab active states
    this.tabTargets.forEach(tab => {
      const isActive = tab.dataset.section === section
      
      // Desktop left sidebar styles
      tab.classList.toggle("md:bg-[#F0EEE9]", isActive)
      tab.classList.toggle("md:text-[#1A1A18]", isActive)
      tab.classList.toggle("md:font-semibold", isActive)
      tab.classList.toggle("md:border-l-[3px]", isActive)
      tab.classList.toggle("md:border-l-[#2D6A4F]", isActive)
      tab.classList.toggle("md:rounded-l-none", isActive)
      tab.classList.toggle("md:text-[#6B6860]", !isActive)
      tab.classList.toggle("md:font-medium", !isActive)

      // Mobile top pill styles
      tab.classList.toggle("bg-[#2D6A4F]", isActive)
      tab.classList.toggle("text-white", isActive)
      tab.classList.toggle("bg-transparent", !isActive)
      tab.classList.toggle("text-[#6B6860]", !isActive)
    })

    // Switch panel visibility with fade
    this.panelTargets.forEach(panel => {
      if (panel.dataset.section === section) {
        panel.classList.remove("hidden")
        panel.style.opacity = 0
        panel.style.position = "relative"
        requestAnimationFrame(() => {
          panel.style.transition = "opacity 150ms ease"
          panel.style.opacity = 1
        })
      } else {
        panel.style.opacity = 0
        panel.style.position = "absolute"
        setTimeout(() => panel.classList.add("hidden"), 80)
      }
    })

    // Dim save button on Security tab
    const saveBtns = this.element.querySelectorAll("[data-save-btn]")
    saveBtns.forEach(saveBtn => {
      if (section === "security") {
        saveBtn.classList.add("opacity-40", "pointer-events-none", "cursor-not-allowed")
      } else {
        saveBtn.classList.remove("opacity-40", "pointer-events-none", "cursor-not-allowed")
      }
    })
  }
}
