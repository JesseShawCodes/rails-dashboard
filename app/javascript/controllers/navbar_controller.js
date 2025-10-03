import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["burger", "menu"]

  connect() {
    this.burgerTarget.addEventListener("click", () => {
      this.burgerTarget.classList.toggle("is-active")
      this.menuTarget.classList.toggle("is-active")
    })
  }
}
