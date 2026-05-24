import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "preview", "placeholder"]

  preview(event) {
    const input = event.target
    if (input.files && input.files[0]) {
      const reader = new FileReader()
      
      reader.onload = (e) => {
        this.previewTarget.src = e.target.result
        this.previewTarget.classList.remove("hidden")
        
        if (this.hasPlaceholderTarget) {
          this.placeholderTarget.classList.add("hidden")
        }
      }
      
      reader.readAsDataURL(input.files[0])
    }
  }
}
