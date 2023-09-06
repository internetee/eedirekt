import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content"];
  static classes = ['props'];

  toggle() {
    this.contentTarget.classList.toggle(this.propsClass);
  }
}
