// app/javascript/controllers/debounce_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form"]

  clearForm() {
    this.formTarget.reset();
    this.formTarget.requestSubmit();
  }
}