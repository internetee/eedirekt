import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["list", "template"];
  static values = { 
    childIndex: String 
  };

  addElement(event) {
    event.preventDefault();

    console.log(this.childIndexValue);

    const uniqueId = new Date().getTime();
    let newContactTemplate = this.templateTarget.innerHTML.replace(new RegExp(this.childIndexValue, 'g'), uniqueId);
    this.listTarget.insertAdjacentHTML("beforeend", newContactTemplate);
  }

  removeElement(event) {
    event.preventDefault();
    event.target.closest(".contact-item").remove();
  }
}
