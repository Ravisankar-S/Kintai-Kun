import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "timeFields", "fixedBtn", "flexBtn"]

  connect() {
    this.update(this.inputTarget.value)
  }

  select(event) {
    const value = event.currentTarget.dataset.value
    this.inputTarget.value = value
    this.update(value)
  }

  update(value) {
    const isFixed = value === "fixed"

    // Swap button active state
    this.fixedBtnTarget.classList.toggle("bg-[#2D6A4F]", isFixed)
    this.fixedBtnTarget.classList.toggle("text-white", isFixed)
    this.fixedBtnTarget.classList.toggle("shadow-[0_1px_3px_rgba(0,0,0,0.15)]", isFixed)
    this.fixedBtnTarget.classList.toggle("bg-transparent", !isFixed)
    this.fixedBtnTarget.classList.toggle("text-[#6B6860]", !isFixed)

    this.flexBtnTarget.classList.toggle("bg-[#2D6A4F]", !isFixed)
    this.flexBtnTarget.classList.toggle("text-white", !isFixed)
    this.flexBtnTarget.classList.toggle("shadow-[0_1px_3px_rgba(0,0,0,0.15)]", !isFixed)
    this.flexBtnTarget.classList.toggle("bg-transparent", isFixed)
    this.flexBtnTarget.classList.toggle("text-[#6B6860]", isFixed)

    // Show/hide time fields with slide animation
    if (isFixed) {
      this.timeFieldsTarget.classList.remove("hidden")
      // need a small tick to let the display:none clear before animating max-height
      requestAnimationFrame(() => {
        this.timeFieldsTarget.style.maxHeight = this.timeFieldsTarget.scrollHeight + "px"
      })
    } else {
      this.timeFieldsTarget.style.maxHeight = "0"
      setTimeout(() => this.timeFieldsTarget.classList.add("hidden"), 250)
    }
  }
}
