import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['template', 'container']
  static classes = ['parentDeletable'];

  addContact() {
    var templateHtml = this.templateTarget.innerHTML
    this.containerTarget.insertAdjacentHTML('beforeend', templateHtml)
  }

  remove(event) {
    const className = '.' + this.parentDeletableClass;
    event.target.closest(className).remove();
  }
}
