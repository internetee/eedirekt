import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { delay: { type: Number, default: 2 } };

  connect() {
    if (this.delayValue) {
      this.delayTid = setTimeout(() => {
        this.hide();
        delete this.delayTid;
      }, this.delayValue * 1000);

    }
  }

  disconnect() {
    if (this.delayTid) {
      clearTimeout(this.delayTid);
    }
  }

  hide() {
    this.element.remove();
  }
}
