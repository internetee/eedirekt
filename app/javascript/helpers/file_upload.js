import { DirectUpload } from "@rails/activestorage"

	export class FileUpload {
		constructor(file, uploadUrl, delegate) {
			this.delegate = delegate
			this.directUpload = new DirectUpload(
				file, uploadUrl, this
			)
		}
	start() {
	this.directUpload.create(this.directUploadDidComplete.bind(this))
	this.delegate.fileUploadDidStart(this)
	}
	
	// `DirectUpload` delegate method
	directUploadWillStoreFileWithXHR(xhr) {
		xhr.upload.addEventListener("progress", event => {
		const progress = event.loaded / event.total * 100
		this.delegate.setFileUploadProgress(progress)
	})
	}
	directUploadDidComplete(error, attributes) {
		this.delegate.fileUploadDidComplete(error, attributes)
	}
}
