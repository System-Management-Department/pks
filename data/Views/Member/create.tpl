{block name="title"}
<nav class="navbar navbar-light bg-light">
	<h2 class="container-fluid">新規登録</h2>
</nav>
{/block}

{block name="styles" append}
<link rel="stylesheet" type="text/css" href="/assets/flatpickr/flatpickr.min.css" />
<style type="text/css">{literal}
#pdf .thumbnail{
	display: inline-block;
	width: 100px;
	height: 100px;
	object-fit: contain;
	margin: 3px;
	border: 1px solid black;
    background-color: gray;
	filter: brightness(0.8);
}
#pdf [name="pdf"]{
	display: contents;
}
#pdf [name="pdf"]:checked~.thumbnail{
	outline: 4px solid blue;
	filter: none;
}
.d-contents{
	display: contents;
}
{/literal}</style>
{/block}

{block name="scripts" append}
<script type="text/javascript" src="/assets/flatpickr/flatpickr.min.js"></script>
<script type="text/javascript" src="/assets/pdfjs/build/pdf.js"></script>
<script type="text/javascript" src="/assets/common/form.js"></script>
<script type="text/javascript">
let url = "{url action="index"}";{literal}
let fileMap = new Map();
let thumbnail = null;
let pdfObject = {};
let formObject = {};
let videoObject = {};
document.addEventListener('DOMContentLoaded', pdfObject);
document.addEventListener('dragover', pdfObject);
document.addEventListener('drop', pdfObject);
document.addEventListener('mouseup', pdfObject);
pdfObject.handleEvent = function(e){
	if(e.type == "DOMContentLoaded"){
		this.viewer = document.querySelector('.grid-item1 .blank');
		this.image = document.querySelector('.grid-item2 .blank');
		document.querySelector('form').addEventListener("submit", formObject);
		document.querySelector('.btn-rec').addEventListener("click", videoObject);
		videoObject.container = document.getElementById("video");
		videoObject.video = null;
		videoObject.mediaRecorder = null;
		videoObject.blob = null;
		
		flatpickr('input[type="date"]');
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
	}else if(e.type == "dragover"){
	    e.preventDefault();
	    e.dataTransfer.dropEffect = 'copy';
	}else if(e.type == "drop"){
		e.stopPropagation();
		e.preventDefault();
		const n = e.dataTransfer.files.length;
		for(let i = 0; i < n; i++){
			const file = e.dataTransfer.files[i];
			const matches = file.type.match(/^(video\/webm|application\/pdf|application\/vnd\.)/);
			if(!matches){
				continue;
			}
			if(matches[1] == "video/webm"){
				alert(file.name);
			}else if(matches[1] == "application/pdf"){
				let label = document.createElement("label");
				let radio = document.createElement("input");
				let canvas = document.createElement("canvas");
				label.setAttribute("class", "d-contents");
				radio.setAttribute("type", "radio");
				radio.setAttribute("name", "pdf");
				canvas.setAttribute("class", "thumbnail");
				label.appendChild(radio);
				label.appendChild(canvas);
				document.getElementById("pdf").appendChild(label);
				fileMap.set(canvas, file);
				
				let objectUrl = URL.createObjectURL(file);
				pdfjsLib.workerSrc = "/assets/pdfjs/build/pdf.worker.js";
				pdfjsLib.getDocument(objectUrl).promise.then(pdf => {
					URL.revokeObjectURL(objectUrl);
					return pdf.getPage(1);
				}).then(page => {
					const scale = 100 / Math.max(page._pageInfo.view[2], page._pageInfo.view[3]);
					const viewport = page.getViewport({scale: scale});
					const ctx = canvas.getContext('2d');
					canvas.height = viewport.height;
					canvas.width = viewport.width;
					return page.render({
						canvasContext: ctx,
						viewport: viewport
					});
				}).then(() => {
					document.querySelector('#pdf [name="pdf"]').checked = true;
					document.querySelector('#pdf [name="pdf"]:checked~.thumbnail').toBlob(blob => {thumbnail = blob;}, "image/png");
				});
			}else{
				let label = document.createElement("div");
				let canvas = document.createElement("canvas");
				label.setAttribute("class", "d-contents");
				canvas.setAttribute("class", "thumbnail");
				canvas.width = 100;
				canvas.height = 100;
				label.appendChild(canvas);
				document.getElementById("vnd").appendChild(label);
				fileMap.set(canvas, file);
			}
		};
	}else if(e.type == "mouseup"){
		let canvas = document.querySelector('#pdf [name="pdf"]:checked~.thumbnail');
		if(canvas != null){
			canvas.toBlob(blob => {thumbnail = blob;}, "image/png");
		}
	}
}
videoObject.handleEvent = function(e){
	if(this.video == null){
		navigator.mediaDevices.getUserMedia({audio: true, video: true}).then(mediaStream => {
			this.video = document.createElement("video");
			this.video.setAttribute("autoplay", "autoplay");
			this.video.setAttribute("controls", "controls");
			this.video.setAttribute("playsinline", "playsinline");
			this.container.innerHTML = "";
			this.container.appendChild(this.video);
			this.recordedData = [];
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
			});
			this.video.srcObject = mediaStream;
			this.video.onloadedmetadata = () => {
				this.mediaRecorder.start();
				this.video.play();
			};
		});
	}else{
		let stream = this.video.srcObject;
		let tracks = stream.getTracks();
		this.mediaRecorder.stop()
		tracks.forEach(function(track) {
			track.stop();
		});
		this.video.srcObject = null;
	}
}
formObject.handleEvent = function(e){
	e.stopPropagation();
	e.preventDefault();
	
	const form = e.currentTarget;
	const formData = new FormData(form);
	let i = 0;
	for(let file of fileMap.values()){
		formData.append(`archive[${i}]`, file, file.name);
		formData.append(`files[${i}][name]`, file.name);
		formData.append(`files[${i}][type]`, file.type);
		i++;
	}
	if(thumbnail != null){
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
				document.querySelector('form [data-name="keyword"]').classList.add("is-invalid");
				document.querySelector('form [data-name="keyword"]~.invalid-feedback').textContent = messages.keyword;
			}else{
				document.querySelector('form [data-name="keyword"]').classList.remove("is-invalid");
			}
			if("thumbnail" in messages){
				document.querySelector('#pdf').classList.add("is-invalid");
				document.querySelector('#pdf~.invalid-feedback').textContent = messages.thumbnail;
			}else{
				document.querySelector('#pdf').classList.remove("is-invalid");
			}
		}
	});
}
{/literal}</script>
{/block}

{block name="body"}
<form action="{url action="regist"}" method="POST" class="container-fluid row">
	<label for="e{counter skip=0}" class="col-12 form-label">提案年月日（必須）</label>
	<div class="col-12 col-md-6 col-lg-5 mb-1">
		<input type="date" name="modified_date" id="e{counter skip=1}" class="form-control" placeholder="日付を選択してください" />
		<div class="invalid-feedback"></div>
	</div>
	
	<div class="mt-5 row">
		<div class="col-12 col-md-6 col-lg-5">
			<label for="e{counter skip=0}" class="col-12">クライアント名（必須）</label>
			<div>
				<select name="client" id="e{counter skip=1}" class="form-control">
					<option value="" selected hidden>クライアントを選択</option>
					<option value=""></option>
					{foreach from=$clients key="code" item="data"}
					<option value="{$code}">{$data.name}</option>
					{/foreach}
				</select>
				<div class="invalid-feedback"></div>
			</div>
		</div>
		
		<div class="col-12 col-md-6 col-lg-5 mt-5 mt-md-0">
			<label for="e{counter skip=0}" class="col-12">商材名（必須）</label>
			<div>
				<input name="product_name" type="text" id="e{counter skip=1}" class="form-control" placeholder="入力してください" />
				<div class="invalid-feedback"></div>
			</div>
		</div>
	</div>
	
	<label for="e{counter skip=0}" class="col-12 mt-5 form-label">クライアント　カテゴリー（必須）</label>
	<div class="col-12 col-lg-10">
		<div class="row">
			<div class="col-12 col-md-4" data-categories="l">
				<select name="categories[]" class="form-control" id="e{counter skip=1}">
					<option value="" selected hidden>大項目</option>
					<option value=""></option>
					{foreach from=$categoriesL key="code" item="data"}
						<option value="{$code}">{$data.name}</option>
					{/foreach}
				</select>
				<div class="invalid-feedback"></div>
			</div>
			<div class="col-12 col-md-4 mt-1 mt-md-0">
				<div data-categories="m">
					<select name="categories[]" class="form-control" data-parent="">
						<option value="" selected hidden>中項目</option>
						<option value=""></option>
					</select>
					<fieldset disabled hidden>
						{foreach from=$categoriesM key="parent" item="categories"}
						<select name="categories[]" class="form-control" data-parent="{$parent}">
							<option value="" selected hidden>中項目</option>
							<option value=""></option>
							{foreach from=$categories key="code" item="data"}
								<option value="{$code}">{$data.name}</option>
							{/foreach}
						</select>
						{/foreach}
					</fieldset>
				</div>
				<div class="invalid-feedback"></div>
			</div>
			<div class="col-12 col-md-4 mt-1 mt-md-0">
				<div data-categories="s">
					<select name="categories[]" class="form-control" data-parent="">
						<option value="" selected hidden>小項目</option>
						<option value=""></option>
					</select>
					<fieldset disabled hidden>
						{foreach from=$categoriesS key="parent" item="categories"}
						<select name="categories[]" class="form-control" data-parent="{$parent}">
							<option value="" selected hidden>小項目</option>
							<option value=""></option>
							{foreach from=$categories key="code" item="data"}
								<option value="{$code}">{$data.name}</option>
							{/foreach}
						</select>
						{/foreach}
					</fieldset>
				</div>
				<div class="invalid-feedback"></div>
			</div>
		</div>
	</div>
	
	<label for="e{counter skip=0}" class="col-12 mt-5 form-label">ターゲット（必須）</label>
	<div class="col-12">
		<div data-name="targets">
			{foreach from=$targets key="code" item="data"}
			<div class="form-check form-check-inline">
				<input type="checkbox" name="targets[]" id="e{counter skip=0}" value="{$code}" class="form-check-input" /><label for="e{counter skip=1}" class="form-check-label">{$data.name}</label>
			</div>
			{/foreach}
		</div>
		<div class="invalid-feedback"></div>
	</div>
	
	<label for="e{counter skip=0}" class="col-12 mt-5 form-label">媒体（必須）</label>
	<div class="col-12">
		<div data-name="medias">
			{foreach from=$medias key="code" item="data"}
			<div class="form-check form-check-inline">
				<input type="checkbox" name="medias[]" id="e{counter skip=0}" value="{$code}" class="form-check-input" /><label for="e{counter skip=1}" class="form-check-label">{$data.name}</label>
			</div>
			{/foreach}
		</div>
		<div class="invalid-feedback"></div>
	</div>
	
	<label class="col-12 mt-5 form-label">関係者スタッフ名（任意）</label>
	<div class="row">
		<div class="col-12 col-md-6 col-lg-5">
			<label for="e{counter skip=0}" class="col-12">営業担当者名</label>
			<div>
				<input name="sales_staff" type="text" id="e{counter skip=1}" class="form-control" placeholder="入力してください" />
				<div class="invalid-feedback"></div>
			</div>
			
			<label for="e{counter skip=0}" class="col-12 mt-3">コピーライター</label>
			<div>
				<input name="copywriter" type="text" id="e{counter skip=1}" class="form-control" placeholder="入力してください" />
				<div class="invalid-feedback"></div>
			</div>
		</div>
		
		<div class="col-12 col-md-6 col-lg-5 mt-3 mt-md-0">
			<label for="e{counter skip=0}" class="col-12">プランナー</label>
			<div>
				<input name="planner" type="text" id="e{counter skip=1}" class="form-control" placeholder="入力してください" />
				<div class="invalid-feedback"></div>
			</div>
			
			<label for="e{counter skip=0}" class="col-12 mt-3">デザイナー</label>
			<div>
				<input name="designer" type="text" id="e{counter skip=1}" class="form-control" placeholder="入力してください" />
				<div class="invalid-feedback"></div>
			</div>
		</div>
	</div>
	
	<label for="e{counter skip=0}" class="col-12 mt-5 form-label">提案内容／ポイント（必須）</label>
	<div class="col-12 col-lg-10">
		<textarea name="content" type="text" id="e{counter skip=1}" class="form-control" placeholder="入力してください"></textarea>
		<div class="invalid-feedback"></div>
	</div>
	
	
	<label for="e{counter skip=0}" class="col-12 mt-5 form-label">検索キーワード （必須）（成分名、オンパレ、タレント名など絞り込みやすい検索ワード）</label>
	<div>
		<div class="row" data-name="keyword">
			{for $foo=1 to 6}
			<div class="col-12 col-md-6 col-lg-5 mb-1"><input type="text" name="keyword[]" id="e{counter skip=1}" class="form-control" placeholder="入力してください" /></div>
			{/for}
		</div>
		<div class="invalid-feedback"></div>
	</div>
	
	<label for="e{counter skip=0}" class="col-12 mt-5 form-label">メディアライブラリ（PDF）</label>
	<div class="col-12">
		<div class="d-flex flex-wrap gap-3" id="pdf">
			<div class="card mb-3 d-flex text-center" style="height: 120px; width: 120px; justify-content: center; background: #f0f3f5; border: 3px dotted darkgray; color: #14a5ad; font-weight: bold; margin-right: 30px;">ファイルを選択</div>
		</div>
		<div class="invalid-feedback"></div>
	</div>
	
	<label for="e{counter skip=0}" class="col-12 mt-5 form-label">メディアライブラリ（PowerPoint、Keynote、Excelなど）</label>
	<div class="col-12">
		<div class="d-flex flex-wrap gap-3" id="vnd">
			<div class="card mb-3 d-flex text-center" style="height: 120px; width: 120px; justify-content: center; background: #f0f3f5; border: 3px dotted darkgray; color: #14a5ad; font-weight: bold; margin-right: 30px;">ファイルを選択</div>
		</div>
	</div>
	
	<label for="e{counter skip=0}" class="col-12 mt-5 form-label">説明録画（任意）</label>
	<div class="col-12">
		<button type="button" class="btn btn-info btn-rec">Rec</button>
		<div id="video"></div>
	</div>
	
	<div class="col-12 mt-5 text-center">
		<button type="submit" class="btn btn-success rounded-pill w-25 d-inline-flex"><div class="flex-grow-1"></div>キャンセル<div class="flex-grow-1"></div></button>
		<button type="submit" class="btn btn-success rounded-pill w-25 d-inline-flex"><div class="flex-grow-1"></div>編集保存<div class="flex-grow-1"></div></button>
	</div>
</form>
{/block}