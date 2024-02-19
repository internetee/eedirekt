import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["elements"];
  static classes = ['props'];

  toggle() {
    this.elementsTargets.forEach(element => {
      if (element.classList.contains(this.propsClass)) {
        element.classList.remove(this.propsClass);
      } else {
        element.classList.add(this.propsClass);
      }
    });
  }
}
