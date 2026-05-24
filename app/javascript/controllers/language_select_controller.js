import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "enBtn", "jaBtn"]

  connect() {
    this.update(this.inputTarget.value)
  }

  select(event) {
    const value = event.currentTarget.dataset.value
    this.inputTarget.value = value
    this.update(value)
  }

  update(value) {
    const isEn = value === "en"
    
    this.enBtnTarget.classList.toggle("bg-[#2D6A4F]", isEn)
    this.enBtnTarget.classList.toggle("text-white", isEn)
    this.enBtnTarget.classList.toggle("shadow-[0_1px_3px_rgba(0,0,0,0.15)]", isEn)
    this.enBtnTarget.classList.toggle("bg-transparent", !isEn)
    this.enBtnTarget.classList.toggle("text-[#6B6860]", !isEn)
    
    this.jaBtnTarget.classList.toggle("bg-[#2D6A4F]", !isEn)
    this.jaBtnTarget.classList.toggle("text-white", !isEn)
    this.jaBtnTarget.classList.toggle("shadow-[0_1px_3px_rgba(0,0,0,0.15)]", !isEn)
    this.jaBtnTarget.classList.toggle("bg-transparent", isEn)
    this.jaBtnTarget.classList.toggle("text-[#6B6860]", isEn)
  }
}
