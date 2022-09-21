{block name="title"}
<nav class="navbar navbar-light bg-light">
	<h2 class="container-fluid">新規登録</h2>
</nav>
{/block}

{block name="styles" append}
<link rel="stylesheet" href="/assets/flatpickr/flatpickr.min.css">
{/block}

{block name="scripts" append}
<script src="/assets/flatpickr/flatpickr.min.js"></script>
<script type="text/javascript">{literal}
var pdfObject = {file: null, thumbnail: null};
var formObject = {};
document.addEventListener('DOMContentLoaded', pdfObject);
document.addEventListener('dragover', pdfObject);
document.addEventListener('drop', pdfObject);
pdfObject.handleEvent = function(e){
	if(e.type == "DOMContentLoaded"){
		this.viewer = document.querySelector('.grid-item1 .blank');
		this.image = document.querySelector('.grid-item2 .blank');
		document.querySelector('form').addEventListener("submit", formObject);
		
		flatpickr('input[type="date"]');
	}else if(e.type == "dragover"){
	    e.preventDefault();
	    e.dataTransfer.dropEffect = 'copy';
	}else if(e.type == "drop"){
		e.stopPropagation();
		e.preventDefault();
		const n = e.dataTransfer.files.length;
		for(let i = 0; i < n; i++){
			const file = e.dataTransfer.files[i];
			if(file.type == "video/webm"){
				alert(file.name);
				continue;
			}else if(file.type != "application/pdf"){
				continue;
			}
			let iframe = document.createElement("iframe");
			iframe.setAttribute("src", `/assets/pdfjs/custom_viewer.html?file=${URL.createObjectURL(file)}`);
			this.viewer.parentNode.replaceChild(iframe, this.viewer);
			this.viewer = iframe;
			this.file = file;
		};
	}
}
pdfObject.replaceThumbnail = function(data){
	const img = document.createElement("img");
	img.setAttribute("src", data);
	this.image.parentNode.replaceChild(img, this.image);
	this.image = img;
}
formObject.handleEvent = function(e){
	e.stopPropagation();
	e.preventDefault();
	const form = e.currentTarget;
	const formData = new FormData(form);
	formData.append("file", pdfObject.file, pdfObject.file.name);
	formData.append("thumbnail", pdfObject.thumbnail, "thumbnail");
	fetch(form.getAttribute("action"), {
		method: form.getAttribute("method"),
		body: formData,
		headers: {
			"X-CSRF-Token": "{{ csrfToken }}"
		},
	}).then(res => res.text()).then(text => console.log(text));
}
{/literal}</script>
{/block}

{block name="body"}
<form action="{url action="regist"}" method="POST" class="container-fluid row">
	<label for="e{counter skip=0}" class="col-12 form-label">提案年月日</label>
	<div class="col-12 col-md-6 col-lg-5 mb-1">
		<input type="date" name="modified_date" id="e{counter skip=1}" class="form-control" placeholder="日付を選択してください" />
	</div>
	
	<label for="e{counter skip=0}" class="col-12 mt-5 form-label">クライアント名</label>
	<div class="col-12">
		<select name="client" id="e{counter skip=1}" class="form-control">
			<option value="" disabled selected>入力してください</option>
			{foreach from=$clients key="code" item="data"}
			<option value="{$code}">{$data}</option>
			{/foreach}
		</select>
	</div>
	
	<label for="e{counter skip=0}" class="col-12 mt-5 form-label">クライアント業種</label>
	<div class="col-12 col-md-4">
		<select name="categories[]" id="e{counter skip=1}" class="form-control">
			<option value="" disabled selected>大分類</option>
		</select>
	</div>
	<div class="col-12 col-md-4">
		<select name="categories[]" id="e{counter skip=1}" class="form-control">
			<option value="" disabled selected>中分類</option>
		</select>
	</div>
	<div class="col-12 col-md-4">
		<select name="categories[]" id="e{counter skip=1}" class="form-control">
			<option value="" disabled selected>小分類</option>
		</select>
	</div>
	
	<label for="e{counter skip=0}" class="col-12 mt-5 form-label">ターゲット</label>
	<div class="col-12">
		{foreach from=["1" => "女性向け", "2" => "男性向け", "3" => "シニア向け", "4" => "特になし"] key="code" item="data"}
		<label><input type="checkbox" name="targets[]" id="e{counter skip=1}" value="{$code}" />{$data}</label>
		{/foreach}
	</div>
	
	<label for="e{counter skip=0}" class="col-12 mt-5 form-label">媒体</label>
	<div class="col-12">
		{foreach from=["1" => "新聞掲載", "2" => "新聞折込", "3" => "インフォマ", "4" => "雑誌掲載", "5" => "ＷＥＢ", "6" => "ＤＭ", "7" => "リーフレット", "8" => "会報誌"] key="code" item="data"}
		<label><input type="checkbox" name="meadias[]" id="e{counter skip=1}" value="{$code}" />{$data}</label>
		{/foreach}
	</div>
	
	<label for="e{counter skip=0}" class="col-12 mt-5 form-label">関係者スタッフ名</label>
	<div class="col-12">
		<input type="text" name="staff" id="e{counter skip=1}" class="form-control" />
	</div>
	
	
	<label for="e{counter skip=0}" class="col-12 mt-5 form-label">タグ検索キーワード</label>
	{for $foo=1 to 6}
	<div class="col-12 col-md-6 col-lg-5 mb-1"><input type="text" name="keyword[]" id="e{counter skip=1}" class="form-control" placeholder="入力してください" /></div>
	{/for}
	
	<label for="e{counter skip=0}" class="col-12 mt-5 form-label">メディアライブラリ</label>
	<div class="col-12">
		<div class="card text-center">
			<div class="card-body">
				<div>ファイルをドロップしてアップロード</div>
				<div>または、</div>
				<input type="file" class="btn btn-outline-primary" />
			</div>
		</div>
	</div>
	
	
	<label for="e{counter skip=0}" class="col-12 mt-5 form-label"></label>
	<div class="col-12">
		<div class="card text-center">
			<div class="card-body">
				<a href="https://script.google.com/a/macros/direct-holdings.co.jp/s/AKfycbzF-fRhUug6YhDn074ogU38PeIP3OULYdicd1NDAkgsXQWnrLLCgkwQXEa_uUK2MKVa/exec" target="_blank" class="btn btn-info">撮影</a>
			</div>
		</div>
	</div>
	
	
	<div class="col-12 mt-5 text-center"><button type="submit" class="btn btn-success rounded-pill w-25 d-inline-flex"><div class="flex-grow-1"></div>検<div class="flex-grow-1"></div>索<div class="flex-grow-1"></div></button></div>
	
		<div class="grid-item1">
			<div class="blank">PDF プレビュー</div>
		</div>
		<div class="grid-item2">
			<div class="blank"></div>
		</div>
</form>
{/block}