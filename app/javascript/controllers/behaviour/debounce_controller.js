// app/javascript/controllers/debounce_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form"]

  initialize() {
    this.timeout = null;
    this.initialLoad = true;
  }


  search(event) {
    if (this.initialLoad) {
      this.initialLoad = false;
      return;
    }

    clearTimeout(this.timeout);
    this.timeout = setTimeout(() => {
      this.formTarget.requestSubmit();
    }, 500);
  }

  disconnect() {
    clearTimeout(this.timeout);
  }
}
