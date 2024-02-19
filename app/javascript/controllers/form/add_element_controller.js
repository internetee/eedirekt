import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["list", "template"];
  static values = { 
    childIndex: String,
    limitOfElements: { type: Number, default: 9 },
    currentElements: { type: Number, default: 1 }
  };

  addElement(event) {
    event.preventDefault();

    if (this.currentElementsValue >= this.limitOfElementsValue) {
      return;
    }

    const uniqueId = new Date().getTime();
    let newContactTemplate = this.templateTarget.innerHTML.replace(new RegExp(this.childIndexValue, 'g'), uniqueId);
    this.listTarget.insertAdjacentHTML("beforeend", newContactTemplate);

    this.currentElementsValue++;
  }

  removeElement(event) {
    event.preventDefault();
  
    let invoiceItemElement = event.target.closest(".contact-item");
  
    let destroyField = invoiceItemElement.querySelector("input[name$='[_destroy]']");
  
    if (destroyField) {
      destroyField.value = '1';
      invoiceItemElement.style.display = 'none';
    }
  }
}
