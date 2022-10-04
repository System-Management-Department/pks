{block name="title"}
<nav class="navbar navbar-light bg-light">
	<h2 class="container-fluid">閲覧画面</h2>
</nav>
{/block}

{block name="styles" append}
<link rel="stylesheet" type="text/css" href="/assets/common/proposal-form.css" />
{/block}

{block name="scripts" append}
<script type="text/javascript" src="/assets/pdfjs/build/pdf.js"></script>
<script type="text/javascript">{literal}
document.addEventListener('DOMContentLoaded', function(){
	let files = document.querySelectorAll('[data-name="files"] a[href][data-type][data-name]');
	let promise = [];
	for(let file of files){
		promise.push(fetch(file.getAttribute("href")).then(response => response.blob()));
	}
	Promise.all(promise).then(blobs => {
		let n = blobs.length;
		for(let i = 0; i < n; i++){
			let type = files[i].getAttribute("data-type");
			if(type.indexOf("application/pdf") == 0){
				let label = document.createElement("label");
				let radio = document.createElement("input");
				let canvas = document.createElement("canvas");
				label.setAttribute("class", "fileicon");
				label.setAttribute("title", files[i].getAttribute("data-name"));
				radio.setAttribute("type", "checkbox");
				radio.setAttribute("name", "filenames[]");
				radio.setAttribute("value", files[i].getAttribute("data-name"));
				canvas.setAttribute("class", "thumbnail");
				label.appendChild(radio);
				label.appendChild(canvas);
				document.getElementById("pdf").appendChild(label);
				
				let objectUrl = URL.createObjectURL(blobs[i]);
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
				});
			}else{
				let label = document.createElement("label");
				let radio = document.createElement("input");
				let canvas = document.createElement("div");
				label.setAttribute("class", "fileicon");
				label.setAttribute("title", files[i].getAttribute("data-name"));
				radio.setAttribute("type", "checkbox");
				radio.setAttribute("name", "filenames[]");
				radio.setAttribute("value", files[i].getAttribute("data-name"));
				canvas.setAttribute("class", "thumbnail");
				canvas.setAttribute("data-type", type);
				label.appendChild(radio);
				label.appendChild(canvas);
				document.getElementById("vnd").appendChild(label);
			}
		}
	});
});
{/literal}</script>
{/block}

{block name="body"}
<div class="container-fluid row">
	<div class="row">
		<div class="col-12 col-md-6 col-lg-5">
			<div class="col-12 form-label">クライアント名</div>
			<div class="col-12">
				<div class="form-control">{$clients[$data.client].name|escape:"html"}</div>
			</div>
		</div>
		
		<div class="col-12 col-md-6 col-lg-5 mt-5 mt-md-0">
			<div class="col-12 form-label">商材名</div>
			<div class="col-12">
				<div class="form-control">{$data.product_name|escape:"html"}</div>
			</div>
		</div>
	</div>
	
	<form class="row" action="{url controller="Archive" action="download"}" method="POST" target="_blank">
		<div class="col-12 mt-5 form-label">メディアライブラリ（PDF）<button type="submit" class="float-end">ダウンロード<i class="fas fa-download"></i></button></div>
		<div class="col-12">
			<div class="d-flex flex-wrap gap-3" id="pdf"></div>
		</div>
	</form>
	<form class="row" action="{url controller="Archive" action="download"}" method="POST" target="_blank">
		<div for="e{counter skip=0}" class="col-12 mt-5 form-label">メディアライブラリ（PowerPoint、Keynote、Excelなど）<button type="submit" class="float-end">ダウンロード<i class="fas fa-download"></i></button></div>
		<div class="col-12">
			<div class="d-flex flex-wrap gap-3" id="vnd"></div>
		</div>
	</form>
	
	<div class="col-12">
		<div data-name="files">{foreach from=$data.files item="file"}
		<a href="{url controller="Archive" action="proposal" id=$file.filename}" data-type="{$file.type|escape:"html"}" data-name="{$file.filename|escape:"html"}"></a>
		{/foreach}</div>
	</div>
	
	<div class="col-12 mt-5 form-label">提案年月日</div>
	<div class="col-12 col-md-6 col-lg-5 mb-1">
		<div class="form-control">{$data.modified_date|escape:"html"}</div>
	</div>
	
	<div class="col-12 mt-5 form-label">クライアント　カテゴリー</div>
	<div class="col-12 col-lg-10">
		<div class="row">
			<div class="col-12 col-md-4">
				<div class="form-control">{$categories[$data.categories[0]].name|escape:"html"}</div>
			</div>
			<div class="col-12 col-md-4 mt-1 mt-md-0">
				<div class="form-control">{$categories[$data.categories[1]].name|escape:"html"}</div>
			</div>
			<div class="col-12 col-md-4 mt-1 mt-md-0">
				<div class="form-control">{$categories[$data.categories[2]].name|escape:"html"}</div>
			</div>
		</div>
	</div>
	
	<div class="col-12 mt-5 form-label">ターゲット</div>
	<div class="col-12">
		<div class="row">
			{foreach from=$data.targets item="target"}
			<div class="col-12 col-md-6 col-lg-4">
				<div class="form-control">{$targets[$target].name|escape:"html"}</div>
			</div>
			{/foreach}
		</div>
	</div>
	
	<div class="col-12 mt-5 form-label">媒体</div>
	<div class="col-12">
		<div class="row">
			{foreach from=$data.medias item="media"}
			<div class="col-12 col-md-6 col-lg-4">
				<div class="form-control">{$medias[$media].name|escape:"html"}</div>
			</div>
			{/foreach}
		</div>
	</div>
	
	<div class="col-12 mt-5 form-label">関係者スタッフ名</div>
	<div class="row">
		<div class="col-12 col-md-6 col-lg-5">
			<div class="col-12">営業担当者名</div>
			<div class="col-12">
				<div class="form-control">{$data.sales_staff|escape:"html"}</div>
			</div>
			
			<div class="col-12 mt-3">コピーライター</div>
			<div class="col-12">
				<div class="form-control">{$data.copywriter|escape:"html"}</div>
			</div>
		</div>
		
		<div class="col-12 col-md-6 col-lg-5 mt-3 mt-md-0">
			<div class="col-12">プランナー</div>
			<div class="col-12">
				<div class="form-control">{$data.planner|escape:"html"}</div>
			</div>
			
			<div class="col-12 mt-3">デザイナー</div>
			<div class="col-12">
				<div class="form-control">{$data.designer|escape:"html"}</div>
			</div>
		</div>
	</div>
	
	<div class="col-12 mt-5 form-label">提案内容／ポイント</div>
	<div class="col-12 col-lg-10">
		<div class="form-control" style="white-space: pre;">{$data.content|escape:"html"}</div>
	</div>
	
	
	<label for="e{counter skip=0}" class="col-12 mt-5 form-label">検索キーワード （成分名、オンパレ、タレント名など絞り込みやすい検索ワード）</label>
	<div>
		<div class="row">
			{foreach from=$data.keywords item="keyword"}
			<div class="col-12 col-md-6 col-lg-5 mb-1"><div class="form-control">{$keyword|escape:"html"}</div></div>
			{/foreach}
		</div>
	</div>
	
	<label for="e{counter skip=0}" class="col-12 mt-5 form-label">説明録画</label>
	{if $data.videoExists}<div class="col-12">
		<video autoplay="autoplay" controls="controls" playsinline="playsinline"><source src="/file/video/{$data.id}.webm" type="video/webm" /></video>
	</div>{/if}
	
	<form class="col-12 mt-5 text-center" action="{url action="edit"}" method="POST">
		<button type="submit" name="proposal" value="{$data.id}" class="btn btn-success rounded-pill w-25 d-inline-flex"><div class="flex-grow-1"></div>編集<div class="flex-grow-1"></div></button>
	</form>
</div>
{/block}