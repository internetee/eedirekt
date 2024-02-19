import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["firstObject", "secondObject"];
  static classes = ['props'];

  toggle() {
    if (this.hasFirstObjectTarget && this.hasSecondObjectTarget) {
      this.firstObjectTarget.classList.toggle(this.propsClass);
      this.secondObjectTarget.classList.toggle(this.propsClass);
    }
  }
}
