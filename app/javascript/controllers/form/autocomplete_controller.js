import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "results", "hiddenInput"]

  connect() {
    this.handleClickOutside = this.handleClickOutside.bind(this)
    document.addEventListener('click', this.handleClickOutside)
  }
  
  disconnect() {
    document.removeEventListener('click', this.handleClickOutside)
  }
  
  handleClickOutside(event) {
    if (!this.element.contains(event.target)) {
      this.resultsTarget.style.display = 'none';
    }
  }

  search(event) {
    event.preventDefault()
    event.stopPropagation()

    const query = this.inputTarget.value

    if (query === "") {
      this.resultsTarget.innerHTML = ""
      return
    }

    fetch(`/registrar/contacts/search?query=${query}`)
      .then((response) => response.json())
      .then((contacts) => {
        const html = contacts.map(contact => `
          <li data-action="click->form--autocomplete#select" data-value="${contact.name} - ${contact.code}" data-id="${contact.id}">
            ${contact.name} - ${contact.ident}
          </li>
        `).join('')
        this.resultsTarget.innerHTML = html
        this.resultsTarget.style.display = contacts.length > 0 ? 'block' : 'none';
      })
  }

  select(event) {
    const value = event.target.getAttribute("data-value")
    const id = event.target.getAttribute("data-id")
    this.inputTarget.value = value
    this.hiddenInputTarget.value = id
    this.resultsTarget.innerHTML = ""
    this.resultsTarget.style.display = 'none';
  }
}
