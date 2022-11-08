let fileMap = new Map();
let fileGridMap = new Map();
let pdfObject = {};
let formObject = {};
let videoObject = {};
let deleteBtn;
document.addEventListener('DOMContentLoaded', pdfObject);
document.addEventListener('dragover', pdfObject);
document.addEventListener('drop', pdfObject);
document.addEventListener('mouseup', pdfObject);
pdfObject.handleEvent = function(e){
	if(e.type == "DOMContentLoaded"){
		this.viewer = document.querySelector('.grid-item1 .blank');
		this.image = document.querySelector('.grid-item2 .blank');
		document.querySelector('form').addEventListener("submit", formObject);
		videoObject.modal = document.querySelector('.btn-rec');
		videoObject.modal.addEventListener("click", videoObject);
		document.querySelector('.btn-rec2').addEventListener("click", videoObject);
		videoObject.container = document.getElementById("video");
		videoObject.video = null;
		videoObject.mediaRecorder = null;
		videoObject.blob = null;
		videoObject.recoding = false;
		
		flatpickr('input[type="date"]', {
			locale: "ja",
			plugins: [
				new monthSelectPlugin({
					shorthand: true,
					dateFormat: "Y-m",
					altFormat: "Y-m"
				})
			]
		});
		let categories = {
			l: document.querySelector('[data-categories="l"] select'),
			m: [...document.querySelectorAll('[data-categories="m"] select')],
			s: [...document.querySelectorAll('[data-categories="s"] select')]
		};
		let changeMEvent = e => {
			let select = e.currentTarget;
			for(let category of categories.s){
				let display = category.getAttribute("data-parent") == select.value;
				document.querySelector(`[data-categories="s"]${display ? "" : " fieldset"}`).appendChild(category);
			}
		};
		let changeLEvent = e => {
			let select = e.currentTarget;
			let nextSelect = null;
			for(let category of categories.m){
				let display = category.getAttribute("data-parent") == select.value;
				document.querySelector(`[data-categories="m"]${display ? "" : " fieldset"}`).appendChild(category);
				if(display){
					nextSelect = category;
				}
			}
			if(nextSelect != null){
				changeMEvent({currentTarget: nextSelect});
			}
		};
		categories.l.addEventListener("change", changeLEvent);
		for(let category of categories.m){
			category.addEventListener("change", changeMEvent);
		}
		changeLEvent({currentTarget: categories.l});
		
		let files = document.querySelectorAll('form [data-name="files"] a[href][data-type][data-name]');
		let promise = [];
		for(let file of files){
			promise.push(fetch(file.getAttribute("href")).then(response => response.blob()));
		}
		Promise.all(promise).then(blobs => this.handleEvent({
			type: "drop",
			dataTransfer: {
				files: blobs.map((blob, i) => {
					return new File([blob], files[i].getAttribute("data-name"), {type: files[i].getAttribute("data-type")})
				})
			},
			stopPropagation: () => {},
			preventDefault: () => {}
		}));
		let source = document.querySelector('#video video source[src][type]');
		if(source != null){
			fetch(source.getAttribute("src")).then(response => response.blob()).then(blob => {videoObject.blob = new Blob([blob], {type: source.getAttribute("type")});});
		}
		
		deleteBtn = document.querySelector('#deleteModal [data-action]');
		if(deleteBtn != null){
			deleteBtn.addEventListener("click", this);
		}
		
		document.querySelector('#deleteModal2 .btn-video-del').addEventListener("click", e => {
			let video = document.querySelector('#video video');
			if(video != null){
				let btn = document.querySelector('.btn-rec2');
				btn.textContent = "録画";
				btn.style.display = null;
				video.parentNode.removeChild(video);
				videoObject.blob = null;
				document.querySelector('[data-bs-target="#deleteModal2"]').textContent = "";
			}
		});
	}else if(e.type == "dragover"){
		e.preventDefault();
		e.dataTransfer.dropEffect = 'copy';
	}else if(e.type == "drop"){
		e.stopPropagation();
		e.preventDefault();
		const n = e.dataTransfer.files.length;
		for(let i = 0; i < n; i++){
			const file = e.dataTransfer.files[i];
			const matches = file.type.match(/^(video\/webm|application\/pdf|image\/|application\/vnd\.)/);
			if(!matches){
				continue;
			}
			if(matches[1] == "video/webm"){
			}else if(matches[1] == "application/pdf"){
				if(file.size > 3 * 1024 * 1024){
					Toaster.show({header: "ファイルアップロードエラー", value: [[`${file.name}のファイルサイズが上限を超えています`, 2]]});
				}else{
					let grid = document.createElement("div");
					let label = document.createElement("label");
					let radio = document.createElement("input");
					let canvas = document.createElement("canvas");
					let icon = document.createElement("i");
					grid.setAttribute("class", "file-grid");
					grid.setAttribute("title", file.name);
					radio.setAttribute("type", "radio");
					radio.setAttribute("name", "pdf");
					canvas.setAttribute("class", "thumbnail");
					icon.setAttribute("class", "bi bi-trash3-fill");
					icon.addEventListener("click", this);
					label.appendChild(radio);
					label.appendChild(canvas);
					grid.appendChild(label);
					grid.appendChild(icon);
					document.getElementById("pdf").appendChild(grid);
					fileMap.set(canvas, file);
					fileGridMap.set(icon, grid);
					
					let objectUrl = URL.createObjectURL(file);
					pdfjsLib.workerSrc = "/assets/pdfjs/build/pdf.worker.js";
					pdfjsLib.getDocument(objectUrl).promise.then(pdf => {
						URL.revokeObjectURL(objectUrl);
						return pdf.getPage(1);
					}).then(page => {
						const scale = 80 / Math.max(page._pageInfo.view[2], page._pageInfo.view[3]);
						const viewport = page.getViewport({scale: scale});
						const ctx = canvas.getContext('2d');
						canvas.height = viewport.height;
						canvas.width = viewport.width;
						return page.render({
							canvasContext: ctx,
							viewport: viewport
						});
					});
				}
			}else{
				let maxSize = file.type.indexOf("application/vnd.openxmlformats-officedocument.presentationml.presentation") == 0
					? 15 * 1024 * 1024
					: 3 * 1024 * 1024;
				if(file.size > maxSize){
					Toaster.show({header: "ファイルアップロードエラー", value: [[`${file.name}のファイルサイズが上限を超えています`, 2]]});
				}else{
					let grid = document.createElement("div");
					let canvas = document.createElement("div");
					let icon = document.createElement("i");
					grid.setAttribute("class", "file-grid");
					grid.setAttribute("title", file.name);
					canvas.setAttribute("class", "thumbnail");
					canvas.setAttribute("data-type", file.type);
					icon.setAttribute("class", "bi bi-trash3-fill");
					icon.addEventListener("click", this);
					grid.appendChild(canvas);
					grid.appendChild(icon);
					document.getElementById("vnd").appendChild(grid);
					fileMap.set(canvas, file);
					fileGridMap.set(icon, grid);
				}
			}
		};
	}else if(e.currentTarget == deleteBtn){
		fetch(deleteBtn.getAttribute("data-action")).then(res => res.json()).then(json => {
			if(json.success){
				Storage.pushToast("過去事例", json.messages);
				location.href = url;
			}else{
				let messages = json.messages.reduce((a, message) => {
					if(message[1] == 2){
						a.push(message[0]);
					}
					return a;
				}, []);
				alert(messages.join("\n"));
			}
		});
	}else if(fileGridMap.has(e.currentTarget)){
		let grid = fileGridMap.get(e.currentTarget);
		let canvas = grid.querySelector('.thumbnail');
		fileGridMap.delete(e.currentTarget);
		fileMap.delete(canvas);
		grid.parentNode.removeChild(grid);
		e.currentTarget.removeEventListener("click", this);
	}
}
videoObject.handleEvent = function(e){
	if(e.currentTarget == videoObject.modal){
		if(this.container.querySelector('video') == null){
			navigator.mediaDevices.getUserMedia({audio: true, video: true}).then(mediaStream => {
				let mediaStreamTracks = [];
				let context = new AudioContext();
				let destination = context.createMediaStreamDestination();
				let tempStream = destination.stream;
				let videoTracks = mediaStream.getVideoTracks();
				for(let track of videoTracks){
					mediaStreamTracks.push(track.clone());
				}
				let audioTracks = tempStream.getAudioTracks();
				for(let track of audioTracks){
					mediaStreamTracks.push(track);
				}
				this.video = document.createElement("video");
				this.video.setAttribute("autoplay", "autoplay");
				this.video.setAttribute("controls", "controls");
				this.video.setAttribute("playsinline", "playsinline");
				this.container.innerHTML = "";
				this.container.appendChild(this.video);
				this.recordedData = [];
				this.recoding = false;
				this.mediaRecorder = new MediaRecorder(mediaStream, {
					mimeType: 'video/webm;codecs=vp8',
					audioBitsPerSecond: 16 * 1000
				});
				this.mediaRecorder.addEventListener("dataavailable", e => {
					this.recordedData.push(e.data);
				});
				this.mediaRecorder.addEventListener("stop", () => {
					this.video.onloadedmetadata = null;
					this.blob = new Blob(this.recordedData , {type: "video/webm;codecs=vp8"});
					let url = URL.createObjectURL(this.blob);
					let source = document.createElement("source");
					source.setAttribute("src", url);
					source.setAttribute("type", "video/webm");
					this.video.appendChild(source);
					this.video = null;
					let now = new Date();
					document.querySelector('[data-bs-target="#deleteModal2"]').textContent = 
						`${now.getFullYear()}-` + `0${now.getMonth() + 1}`.substr(-2) + "-" + `0${now.getDate()}`.substr(-2) + " " +
						`0${now.getHours()}`.substr(-2) + ":" + `0${now.getMinutes()}`.substr(-2) + ":" + `0${now.getSeconds()}`.substr(-2);
				});
				this.video.srcObject = new MediaStream(mediaStreamTracks);
				this.video.onloadedmetadata = () => {
					this.video.play();
					document.querySelector('[data-bs-target="#recModal"]').click();
				};
			});
		}else{
			document.querySelector('[data-bs-target="#recModal"]').click();
		}
	}else{
		if(this.recoding){
			let stream = this.video.srcObject;
			let tracks = stream.getTracks();
			this.mediaRecorder.stop();
			tracks.forEach(function(track) {
				track.stop();
			});
			tracks = this.mediaRecorder.stream.getTracks();
			tracks.forEach(function(track) {
				track.stop();
			});
			this.video.srcObject = null;
			this.recoding = false;
			e.currentTarget.style.display = "none";
		}else{
			this.mediaRecorder.start();
			this.recoding = true;
			e.currentTarget.textContent = "停止";
		}
	}
}
formObject.handleEvent = function(e){
	e.stopPropagation();
	e.preventDefault();
	
	let checkedPdf = document.querySelector('#pdf [name="pdf"]:checked~.thumbnail');
	let gen = submit(e.currentTarget, checkedPdf);
	gen.next();
	if(checkedPdf != null){
		checkedPdf.toBlob(blob => {gen.next(blob);}, "image/png");
	}
	function* submit(form, checkedPdf){
		const formData = new FormData(form);
		let i = 0;
		for(let file of fileMap.values()){
			formData.append(`archive[${i}]`, file, file.name);
			formData.append(`files[${i}][name]`, file.name);
			formData.append(`files[${i}][type]`, file.type);
			i++;
		}
		if(checkedPdf != null){
			let thumbnail = yield;
			formData.append("thumbnail", thumbnail, "thumbnail");
		}
		if(videoObject.blob != null){
			formData.append("video", videoObject.blob, "video");
		}
		fetch(form.getAttribute("action"), {
			method: form.getAttribute("method"),
			body: formData
		}).then(res => res.json()).then(json => {
			if(json.success){
				Storage.pushToast("過去事例", json.messages);
				location.href = url;
			}else{
				let messages = json.messages.reduce((a, message) => {
					if(message[1] == 2){
						a[message[2]] = message[0];
					}
					return a;
				}, {});
				if("modified_date" in messages){
					document.querySelector('form [name="modified_date"]').classList.add("is-invalid");
					document.querySelector('form [name="modified_date"]~.invalid-feedback').textContent = messages.modified_date;
				}else{
					document.querySelector('form [name="modified_date"]').classList.remove("is-invalid");
				}
				if("client" in messages){
					document.querySelector('form [name="client"]').classList.add("is-invalid");
					document.querySelector('form [name="client"]~.invalid-feedback').textContent = messages.client;
				}else{
					document.querySelector('form [name="client"]').classList.remove("is-invalid");
				}
				if("product_name" in messages){
					document.querySelector('form [name="product_name"]').classList.add("is-invalid");
					document.querySelector('form [name="product_name"]~.invalid-feedback').textContent = messages.product_name;
				}else{
					document.querySelector('form [name="product_name"]').classList.remove("is-invalid");
				}
				if("categories0" in messages){
					document.querySelector('form [data-categories="l"] [name="categories[]"]').classList.add("is-invalid");
					document.querySelector('form [data-categories="l"] [name="categories[]"]~.invalid-feedback').textContent = messages.categories0;
				}else{
					document.querySelector('form [data-categories="l"] [name="categories[]"]').classList.remove("is-invalid");
				}
				if("categories1" in messages){
					for(let category of document.querySelectorAll('form [data-categories="m"],form [data-categories="m"] [name="categories[]"]')){
						category.classList.add("is-invalid");
					}
					document.querySelector('form [data-categories="m"]~.invalid-feedback').textContent = messages.categories1;
				}else{
					for(let category of document.querySelectorAll('form [data-categories="m"],form [data-categories="m"] [name="categories[]"]')){
						category.classList.remove("is-invalid");
					}
				}
				if("categories2" in messages){
					for(let category of document.querySelectorAll('form [data-categories="s"],form [data-categories="s"] [name="categories[]"]')){
						category.classList.add("is-invalid");
					}
					document.querySelector('form [data-categories="s"]~.invalid-feedback').textContent = messages.categories2;
				}else{
					for(let category of document.querySelectorAll('form [data-categories="s"],form [data-categories="s"] [name="categories[]"]')){
						category.classList.remove("is-invalid");
					}
				}
				if("targets" in messages){
					document.querySelector('form [data-name="targets"]').classList.add("is-invalid");
					document.querySelector('form [data-name="targets"]~.invalid-feedback').textContent = messages.targets;
				}else{
					document.querySelector('form [data-name="targets"]').classList.remove("is-invalid");
				}
				if("medias" in messages){
					document.querySelector('form [data-name="medias"]').classList.add("is-invalid");
					document.querySelector('form [data-name="medias"]~.invalid-feedback').textContent = messages.medias;
				}else{
					document.querySelector('form [data-name="medias"]').classList.remove("is-invalid");
				}
				if("sales_staff" in messages){
					document.querySelector('form [name="sales_staff"]').classList.add("is-invalid");
					document.querySelector('form [name="sales_staff"]~.invalid-feedback').textContent = messages.sales_staff;
				}else{
					document.querySelector('form [name="sales_staff"]').classList.remove("is-invalid");
				}
				if("copywriter" in messages){
					document.querySelector('form [name="copywriter"]').classList.add("is-invalid");
					document.querySelector('form [name="copywriter"]~.invalid-feedback').textContent = messages.copywriter;
				}else{
					document.querySelector('form [name="copywriter"]').classList.remove("is-invalid");
				}
				if("planner" in messages){
					document.querySelector('form [name="planner"]').classList.add("is-invalid");
					document.querySelector('form [name="planner"]~.invalid-feedback').textContent = messages.planner;
				}else{
					document.querySelector('form [name="planner"]').classList.remove("is-invalid");
				}
				if("designer" in messages){
					document.querySelector('form [name="designer"]').classList.add("is-invalid");
					document.querySelector('form [name="designer"]~.invalid-feedback').textContent = messages.designer;
				}else{
					document.querySelector('form [name="designer"]').classList.remove("is-invalid");
				}
				if("content" in messages){
					document.querySelector('form [name="content"]').classList.add("is-invalid");
					document.querySelector('form [name="content"]~.invalid-feedback').textContent = messages.content;
				}else{
					document.querySelector('form [name="content"]').classList.remove("is-invalid");
				}
				if("keyword" in messages){
					for(let keyword of document.querySelectorAll('form [name="keyword[]"]')){
						keyword.classList.add("is-invalid");
					}
					document.querySelector('form [data-name="keyword"]').classList.add("is-invalid");
					document.querySelector('form [data-name="keyword"]~.invalid-feedback').textContent = messages.keyword;
				}else{
					for(let keyword of document.querySelectorAll('form [name="keyword[]"]')){
						keyword.classList.remove("is-invalid");
					}
					document.querySelector('form [data-name="keyword"]').classList.remove("is-invalid");
				}
				if(("thumbnail" in messages) || ("pdf" in messages)){
					document.querySelector('#pdf').classList.add("is-invalid");
					document.querySelector('#pdf~.invalid-feedback').textContent = ("pdf" in messages) ? messages.pdf : messages.thumbnail;
				}else{
					document.querySelector('#pdf').classList.remove("is-invalid");
				}
				if("vnd" in messages){
					document.querySelector('#vnd').classList.add("is-invalid");
					document.querySelector('#vnd~.invalid-feedback').textContent = messages.vnd;
				}else{
					document.querySelector('#vnd').classList.remove("is-invalid");
				}
				if("files" in messages){
					document.querySelector('form [data-name="files"]').classList.add("is-invalid");
					document.querySelector('form [data-name="files"]~.invalid-feedback').textContent = messages.files;
				}else{
					document.querySelector('form [data-name="files"]').classList.remove("is-invalid");
				}
			}
		});
	}
	
	
}