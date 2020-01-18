// File Upload based https://edgeguides.rubyonrails.org/active_storage_overview.html#direct-uploads
//
class Uploader {

	// File object to upload
	// The file_field select element- should contain data link Url supplied by Rails direct download
	// The progress element ID
	//
	constructor(file, file_select, progress_id) {
		this.file        = file
		this.file_select = file_select
		this.url         = file_select.dataset.directUploadUrl
		this.progress_id = progress_id

		this.upload = new ActiveStorage.DirectUpload(this.file, this.url, this)
	}

	start() {
		console.log('Uploader upload started : ' + this.url);

		var progressBar = document.getElementById(this.progress_id);
		progressBar.style.display = 'inline';

		// We'll deal with progress as %
		progressBar.max = 100;

		this.upload.create((error, blob) => {
			console.log('Direct upload url:' + this.url);

			if (error) {
				// Handle the error
				alert('ERROR ' + error)
			} else {
				// Add an appropriately-named hidden input to the form with a
				// value of blob.signed_id so that the blob ids will be
				// transmitted in the normal upload flow
				const hiddenField = document.createElement('input')
				hiddenField.setAttribute("type", "hidden");
				hiddenField.setAttribute("value", blob.signed_id);
				hiddenField.name = this.file_select.name
				document.querySelector('form').appendChild(hiddenField)
			}
		})
	}

	// Event Listeners to manage Progress bar for active storage based on
	// https://edgeguides.rubyonrails.org/active_storage_overview.html#direct-uploads

	directUploadWillStoreFileWithXHR(request) {
		console.log("directUploadWillStoreFileWithXHR %o", request)
		request.upload.addEventListener("progress", event => this.directUploadDidProgress(event))
	}

	directUploadDidProgress(event) {
		// Use event.loaded and event.total to update the progress bar
		console.log("direct upload progress event: %o", event)
		const progressElement = document.getElementById(this.progress_id)

		let progress = (event.loaded / event.total) * 100;
		progressElement.value = progress;
	}
}

// Hooks for processing different file types once chosen/dropped

function parseAudioFile(file) {

	// TODO better to check type ?
	// audio/mpeg etc
	//var fileType = file.type;
	//console.log('File type: ' + fileType);

	var file_name = file.name;

	var isGood = (/\.(?=wav|mp3|flac|alac|aiff)/gi).test(file_name);

	if (isGood) {
		document.getElementById('start').classList.add("hidden");
		document.getElementById('file-for-track-response').classList.remove("hidden");
		document.getElementById('not-audio-file').classList.add("hidden");

		// Auto fill the for Title field if it's currently empty
		if(!$('#file-upload-title').val()) {
			$('#file-upload-title').val(file_name.replace(/\.[^/.]+$/, ""));
		}
	}
	else {
		document.getElementById('file-image').classList.add("hidden");
		document.getElementById('not-audio-file').classList.remove("hidden");
		document.getElementById('start').classList.remove("hidden");
		document.getElementById('file-for-track-response').classList.add("hidden");
		document.getElementById("file-upload-form").reset();
	}
}

function parseImageFile(file) {

	var file_name = file.name;

	console.log('Image File name: ' + file_name);

	var isGood = (/\.(?=gif|jpg|png)/gi).test(file_name);

	if (isGood) {
		document.getElementById('choose-image-start').classList.add("hidden");
		document.getElementById('file-for-image-response').classList.remove("hidden");
		document.getElementById('not-image-file').classList.add("hidden");

		// Thumbnail Preview

		document.getElementById('file-for-image-preview').classList.remove("background-image");
		document.getElementById('file-for-image-preview').classList.remove("hidden");
		document.getElementById('file-for-image-preview').src = URL.createObjectURL(file);
	}
	else {
		document.getElementById('file-image').classList.add("hidden");
		document.getElementById('not-audio-file').classList.remove("hidden");
		document.getElementById('start').classList.remove("hidden");
		document.getElementById('file-for-image-response').classList.add("hidden");
		document.getElementById("file-upload-form").reset();
	}
}

// Drag n Drop File form based on https://codepen.io/mattsince87/pen/yadZXv
//
function manageUpload(fileSelectID, fileDragID, directUploadProgressID, messagesID, parseFileCallback){

	var fileFieldID = fileSelectID;

	var fileSelect  = document.getElementById(fileFieldID);
	var fileDrag    = document.getElementById(fileDragID);

	var directUploadProgressID  = directUploadProgressID

	//var parseCallback = new Function(parseFileCallback);
	var parseCallback = parseFileCallback;

	function Init() {
		fileSelect.addEventListener('change', fileSelectHandler, false);

		// Is XHR2 available?
		var xhr = new XMLHttpRequest();

		if (xhr.upload) {
			// File Drop
			fileDrag.addEventListener('dragover', fileDragHover, false);
			fileDrag.addEventListener('dragleave', fileDragHover, false);
			fileDrag.addEventListener('drop', fileSelectHandler, false);
		}
	}

	function fileDragHover(e) {
		e.stopPropagation();
		e.preventDefault();

		// TOFIX: whats this actually do ? its messes up the styling opf the inout box - suddenly goes full width
		//fileDrag.className = (e.type === 'dragover' ? 'hover' : 'modal-body file-upload');
	}

	function fileSelectHandler(e) {
		// Fetch FileList object
		var files = e.target.files || e.dataTransfer.files;

		// Cancel event and hover styling
		fileDragHover(e);

		// TODO - How would we support multiple files - currently single form
		// - separate upload from track details form like Soundcloud or bandcamp
		//for (var i = 0, f; f = files[i]; i++) {
		//    parseFile(f);
		//    uploadFile(f);
		//}
		var file = files[0]

		output(file.name);    // show the new filename

		parseCallback(file);

		uploadFile(file);
	}

	// Output response to client
	function output(msg) {
		var outputElement = document.getElementById(messagesID);
		outputElement.innerHTML = msg;
	}

	function uploadFile(file) {
		var uploader = new Uploader(file, fileSelect, directUploadProgressID);

		uploader.start();
	}

	// Check for the various File API support.
	if (window.File && window.FileList && window.FileReader) {
		Init();
	} else {
		fileDrag.style.display = 'none';
	}
}


