import { Controller } from "@hotwired/stimulus"
// import { FileUpload } from "../helpers/file_upload"

export default class extends Controller {
  static values = { 
    serverFailedMsg: String,
    serverSuccessMsg: String,
    sendFormFailedMsg: String,
    uploadErrorMsg: String,
    validationUrl: String,
  }

  connect() {
    // console.log(this.serverFailedMsgValue);
    // console.log(this.serverSuccessMsgValue);
    // console.log(this.sendFormFailedMsgValue);
    // console.log(this.uploadErrorMsgValue);
  }

  upload(event) {
    let crt_file = document.querySelector('#_tld_crt').files[0];
    let key_file = document.querySelector('#_tld_key').files[0];
    let username = document.querySelector('#_tld_username').value;
    let password = document.querySelector('#_tld_password').value;

    if((crt_file == null || crt_file == 'undefined')
        || (key_file == null || key_file == 'undefined')
        || (!username) || (!password)) return;

    // let msgBoxes = document.querySelectorAll('#msg-box');
    let errorBox = document.querySelector('#error-box');

    const formData = new FormData();
    formData.append("crt", crt_file);
    formData.append("key", key_file);
    formData.append("username", username);
    formData.append("password", password);

    clearTimeout(this.timeout);
    this.timeout = setTimeout(async () => {
      try {
        const response = await fetch(this.validationUrlValue, {
          method: "POST",
          body: formData,
          headers: {
            "X-CSRF-Token": document.querySelector("[name=csrf-token]").content,
          },
          credentials: "same-origin",
        });

        const jsonResponse = await response.json();

        if (!response.ok) {          
          errorBox.classList.remove('text-green-500');
          errorBox.classList.add('text-red-500');
          errorBox.textContent = jsonResponse.error;
          return;
        }

        if (jsonResponse.valid) {
          errorBox.classList.remove('text-red-500');
          errorBox.classList.add('text-green-500');
          errorBox.textContent = this.serverSuccessMsgValue;
        } else {
          errorBox.classList.remove('text-green-500');
          errorBox.classList.add('text-red-500');
          errorBox.textContent = this.serverFailedMsgValue;
        }
      } catch (error) {
        errorBox.classList.remove('text-green-500');
        errorBox.classList.add('text-red-500');
        errorBox.textContent = `${this.sendFormFailedMsgValue}: ${error}`
      }
    }, 500);
	}

}
