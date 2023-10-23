import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content", "iconUp", "iconDown"];
  static classes = ['props'];
  static values = { currentIcon: String };

  toggle() {
    this.contentTarget.classList.toggle(this.propsClass);

    if (this.hasIconDownTarget && this.hasIconUpTarget) {
      this.iconUpTarget.classList.toggle("hidden");
      this.iconDownTarget.classList.toggle("hidden");
    }
  }
}
