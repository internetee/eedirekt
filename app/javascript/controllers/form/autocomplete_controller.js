import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "results", "hiddenInput"]
  static values = {
    searchUrl: String,
    initiator: { type: String, default: "registrar" }
  }

  connect() {
    this.handleClickOutside = this.handleClickOutside.bind(this)
    document.addEventListener('click', this.handleClickOutside)
    this.inputTarget.addEventListener('input', this.search.bind(this));
    this.inputTarget.addEventListener('keydown', this.handleKeydown.bind(this));
  }

  disconnect() {
    document.removeEventListener('click', this.handleClickOutside)
    this.inputTarget.removeEventListener('input', this.search);
    this.inputTarget.removeEventListener('keydown', this.handleKeydown);
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

    fetch(`${this.searchUrlValue}?query=${query}`)
      .then((response) => {
        console.log(response);

        return response.json()
      })
      .then((contacts) => {
        console.log(contacts);

        let html = ""

        if (this.initiatorValue === "registrant") {
          html = contacts.map(contact => `
          <li data-action="click->form--autocomplete#select" data-value="${contact.name} - ${contact.code}" data-id="${contact.id}">
            ${contact.name} - ${contact.ident}
          </li>
        `).join('')
        } else {
          html = contacts.map(contact => `
            <li data-action="click->form--autocomplete#select" data-value="${contact.name} - ${contact.code}" data-id="${contact.id}">
              ${contact.name} - ${contact.code}
            </li>
          `).join('')
        }

        this.resultsTarget.innerHTML = html
        this.resultsTarget.style.display = contacts.length > 0 ? 'block' : 'none';

        const matchingContact = contacts.find(contact => contact.code === query);
        if (matchingContact) {
          this.manualSelect(matchingContact);
        }

        this.highlightFirstItem();
      })

    this.highlightFirstItem();
  }

  highlightFirstItem() {
    const firstItem = this.resultsTarget.querySelector('li');
    if (firstItem) firstItem.classList.add('bg-indigo-200');
  }

  handleKeydown(event) {
    if (event.target !== this.inputTarget) return;

    switch (event.keyCode) {
      case 38: // arrow up
        event.preventDefault();
        this.moveHighlight('up');
        break;
      case 40: // arrow down
        event.preventDefault();
        this.moveHighlight('down');
        break;
      case 13: // enter
        event.preventDefault();
        if (this.resultsTarget.style.display !== 'none') {
          this.selectHighlighted();
        } else {
          this.element.submit();
        }
        break;
    }
  }

  moveHighlight(direction) {
    let currentHighlight = this.resultsTarget.querySelector('.bg-indigo-200');
    if (!currentHighlight) {
      this.highlightFirstItem();
      return;
    }

    let newHighlight;
    if (direction === 'up' && currentHighlight.previousElementSibling) {
      newHighlight = currentHighlight.previousElementSibling;
    } else if (direction === 'down' && currentHighlight.nextElementSibling) {
      newHighlight = currentHighlight.nextElementSibling;
    }

    if (newHighlight) {
      currentHighlight.classList.remove('bg-indigo-200');
      newHighlight.classList.add('bg-indigo-200');
    }
  }

  selectHighlighted() {
    const highlighted = this.resultsTarget.querySelector('.bg-indigo-200');
    if (highlighted) {
      highlighted.click();
    }
  }

  select(event) {
    const value = event.target.getAttribute("data-value")
    const id = event.target.getAttribute("data-id")
    this.inputTarget.value = value
    this.hiddenInputTarget.value = id
    this.resultsTarget.innerHTML = ""
    this.resultsTarget.style.display = 'none';
  }

  manualSelect(contact) {
    const value = `${contact.name} - ${contact.code}`;
    const id = contact.id;
    this.inputTarget.value = value;
    this.hiddenInputTarget.value = id;
    this.resultsTarget.innerHTML = "";
    this.resultsTarget.style.display = 'none';
  }
}
