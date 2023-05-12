import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "results", "hiddenInput"]

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
          <li data-action="click->form--autocomplete#select" data-value="${contact.name}" data-id="${contact.id}>
            ${contact.name} - ${contact.ident}
          </li>
        `).join('')
        this.resultsTarget.innerHTML = html
      })
  }

  select(event) {
    const value = event.target.getAttribute("data-value")
    const id = event.target.getAttribute("data-id")
    this.inputTarget.value = value
    this.hiddenInputTarget.value = id
    this.resultsTarget.innerHTML = ""
  }
}
