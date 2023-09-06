import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [
    "input",
    "dropdown",
    "options",
    "selected",
    "tagTemplate",
    "placeholder",
  ];

  connect() {
    this.updateSelectedOptions();
    document.addEventListener("click", (event) => {
      if (event.target.dataset.removeBtn) {
        this.removeOption(event);
      }
    });
    document.addEventListener("click", this.handleClickOutside.bind(this));
  }

  disconnect() {
    document.removeEventListener("click", this.handleClickOutside.bind(this));
  }

  handleClickOutside(event) {
    if (!this.element.contains(event.target) && !this.dropdownTarget.classList.contains("hidden")) {
      this.dropdownTarget.classList.add("hidden");
    }
  }

  toggleDropdown() {
    this.dropdownTarget.classList.toggle("hidden");
  }

  get selectedItems() {
    return this.inputTarget.querySelectorAll("span[data-value]");
  }
  
  selectOption(event) {
    const option = event.currentTarget;
    const value = option.dataset.value;
    const label = option.textContent;
  
    if (!Array.from(this.selectedItems).find((selected) => selected.dataset.value === value)) {
      const tagTemplate = this.tagTemplateTarget.content.cloneNode(true);
      const selectedItem = tagTemplate.querySelector("span");
      selectedItem.dataset.value = value;
      selectedItem.prepend(document.createTextNode(label));
      this.inputTarget.appendChild(selectedItem);
  
      // Удаляем элемент из выпадающего списка
      option.remove();
    }
  
    this.updateSelectedOptions();
    this.toggleDropdown();
    this.updatePlaceholderVisibility();
  }
  
  removeOption(event) {
    event.stopPropagation();
    const selectedItem = event.target.closest("span[data-value]");
    const index = Array.from(this.selectedItems).findIndex((selected) => selected === selectedItem);
  
    if (index > -1) {
      // Добавляем элемент обратно в выпадающий список
      const option = document.createElement("div");
      option.classList.add("option");
      option.textContent = selectedItem.textContent.trim();
      option.dataset.value = selectedItem.dataset.value;
      option.dataset.formMultiSelectTarget = "options";
      option.dataset.action = "click->form--multi_select#selectOption";
      this.dropdownTarget.appendChild(option);
  
      // Удаляем элемент из выбранных
      this.selectedItems[index].remove();
      this.updateSelectedOptions();
    }
    this.updatePlaceholderVisibility();
  }  
  
  updateSelectedOptions() {
    const selectedValues = Array.from(this.selectedItems).map((selected) => selected.dataset.value);
    this.selectedTarget.value = selectedValues.join(",");
  
    this.selectedTarget.dispatchEvent(new Event('input', { bubbles: true }));
  }

  updatePlaceholderVisibility() {
    const tags = this.inputTarget.querySelectorAll("[data-remove-btn]");
    if (tags.length > 0) {
      this.placeholderTarget.classList.add("hidden");
    } else {
      this.placeholderTarget.classList.remove("hidden");
    }
  }
}
