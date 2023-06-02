import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "identInput", "results", "hiddenInput", "nameInput", "countryCodeInput",
                     "stateInput", "streetInput", "cityInput", "zipInput", "phoneInput", "emailInput" ]

  search(event) {
    event.preventDefault()
    event.stopPropagation()

    const query = this.identInputTarget.value

    if (query === "") {
      this.resultsTarget.innerHTML = ""
      return
    }

    fetch(`/registrar/contacts/search?query=${query}`)
      .then((response) => response.json())
      .then((contacts) => {

        console.log(contacts);

        const html = contacts.map(contact => `
          <li data-action="click->form--invoice-autocomplete#select" data-ident="${contact.ident ?? ''}" data-id="${contact.id}" data-name="${contact.name ?? ''}"
              data-country-code="${contact.information.address.country_code  ?? ''}" data-state="${contact.information.address.state ?? ''}"
              data-street="${contact.information.address.street ?? ''}" data-city="${contact.information.address.city ?? ''}" data-zip="${contact.information.address.zip ?? ''}" 
              data-phone="${contact.phone ?? ''}" data-email="${contact.email ?? ''}">
            ${contact.name} - ${contact.ident}
          </li>
        `).join('')
        this.resultsTarget.innerHTML = html
      })
  }

  select(event) {
    this.hiddenInputTarget.value = event.target.getAttribute("data-id")
    this.identInputTarget.value = event.target.getAttribute("data-ident")
    this.nameInputTarget.value = event.target.getAttribute("data-name")
    this.countryCodeInputTarget.value = event.target.getAttribute("data-country-code")
    this.stateInputTarget.value = event.target.getAttribute("data-state")
    this.streetInputTarget.value = event.target.getAttribute("data-street")
    this.cityInputTarget.value = event.target.getAttribute("data-city")
    this.zipInputTarget.value = event.target.getAttribute("data-zip")
    this.phoneInputTarget.value = event.target.getAttribute("data-phone")
    this.emailInputTarget.value = event.target.getAttribute("data-email")
    this.resultsTarget.innerHTML = ""
  }
}
