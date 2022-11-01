{block name="title"}
<nav class="navbar navbar-light bg-light">
	<h2 class="container-fluid px-4">過去事例検索画面</h2>
</nav>
{/block}

{block name="styles" append}
<style type="text/css">{literal}
#mainlist{
	display: grid;
	grid-template-columns: repeat(auto-fill, 80px);
	grid-auto-rows: 80px;
	gap: 6px;
	overflow: auto;
	height: 100%;
	min-width: calc(50% - 90px);
	max-width: 50%;
	flex-shrink: 1;
	padding: 4px;
}
#previewContainer{
	flex-grow: 1;
	overflow: auto;
	height: 100%;
	display: flex;
	flex-direction: column;
	line-height: 1em;
}
#previewContainer .row{
	flex-shrink: 1;
	overflow: auto;
}
#mainlist [data-loading]{
	transition: opacity 0.2s;
}
#mainlist [data-loading="0"]{
	opacity: 0;
}
#mainlist [data-loading="1"]{
	opacity: 1;
}
#mainlist .thumbnail{
	display: block;
	background-size: contain;
	border: 1px solid black;
	background-repeat: no-repeat;
	background-position: center;
	background-color: gray;
	filter: brightness(0.8);
}
#mainlist [name="proposal"]{
	display: contents;
}
#mainlist [name="proposal"]:checked~.thumbnail{
	outline: 4px solid #009ea7;
	filter: none;
}
#mainlist .thumbnail a{
	display: none;
}
#mainlist .not-found{
	grid-column: 1 / -1;
	padding: 10px;
	font-size: 1.5rem;
	font-weight: bold;
	color: red;
}
#previewarea{
	height: calc(70% + 3rem);
}
#previewarea iframe{
	height: 100%;
	width: 100%;
}
#previewContainer #submitBtnArea{
	flex-shrink: 0;
}
#submitBtnArea .btn{
	width: 10em;
}
#pager{
	display: flex;
	justify-content: center;
	gap: 1rem;
	counter-reset: page;
}
#pager [name="page"]{
	counter-increment: page;
	appearance: none;
	color: lightgray;
}
#pager [name="page"]:checked{
	color: blue;
}
#pager [name="page"]::after{
	content: counter(page);
}
.grid1{
	display: grid;
	grid-template-columns: auto 1.5rem auto 1fr;
}
.d-contents{
	display: contents;
}
{/literal}</style>
{/block}

{block name="scripts" append}
<script type="text/javascript">{literal}
document.addEventListener("DOMContentLoaded", function(){
	let current = null;
	let current2 = null;
	let lastBlob = null;
	let form = document.getElementById("searchformdata");
	let loading = document.createElement("span");
	let observer = new IntersectionObserver(() => {
		// 画面内に入ったら更新
		loading.setAttribute("data-loading", loading.getAttribute("data-loading") == "0" ? "1" : "0");
	});
	loading.setAttribute("data-loading", "0");
	observer.observe(loading);
	
	loading.addEventListener("transitionend", () => {
		if(loading.getAttribute("data-loading") == "0"){
			return;
		}
		
		// 一覧の続きを表示
		let list = loading.parentNode;
		list.removeChild(loading);
		fetch(form.getAttribute("action"), {
			method: 'POST',
			body: new FormData(form)
		}).then(response => response.text()).then(html => {
			// サムネイル表示・検索条件の更新
			list.insertAdjacentHTML("beforeend", html);
			let oldInput = form.querySelector('[name="lastdata"]');
			let parent = oldInput.parentNode;
			let newInput = list.querySelector('[name="lastdata"]');
			parent.replaceChild(newInput, oldInput);
			
			if(newInput.value != ""){
				loading.setAttribute("data-loading", "0");
				list.appendChild(loading);
			}
		});
	});
	setTimeout(() => {
		// 最初-件のデータ読み取り
		loading.setAttribute("data-loading", "1");
	}, 200);
	document.getElementById("mainlist").appendChild(loading);
	
	document.addEventListener("mouseup", () => {
		setTimeout(() => {
			let next = document.querySelector('#mainlist [name="proposal"]:checked~.thumbnail');
			if(next != null){
				// 選択の変更
				let val = next.style.backgroundImage;
				if(val != current){
					current = val;
					document.querySelector('[data-name="client"]').textContent = next.getAttribute("data-client");
					document.querySelector('[data-name="product_name"]').textContent = next.getAttribute("data-product-name");
					document.querySelector('[data-name="modified_date"]').textContent = next.getAttribute("data-modified-date");
					document.querySelector('[data-name="targets"]').textContent = next.getAttribute("data-targets");
					document.querySelector('[data-name="medias"]').textContent = next.getAttribute("data-medias");
					document.querySelector('[data-name="keyword"]').textContent = next.getAttribute("data-keyword");
					try{
						let pdfFiles = next.querySelectorAll('a[data-type^="application/pdf"]');
						let files = document.querySelector('[data-name="files"]');
						files.innerHTML = "";
						for(let file of pdfFiles){
							let radio = document.createElement("input");
							radio.setAttribute("type", "radio");
							radio.setAttribute("name", "page");
							radio.setAttribute("value", file.getAttribute("href"));
							radio.setAttribute("class", "btn btn-sm btn-light");
							files.appendChild(radio);
						}
						document.querySelector('[data-name="files"] input[name="page"]').checked = true;
					}catch(e){}
				}
				
				
				val = document.querySelector('[data-name="files"] input[name="page"]:checked').getAttribute("value");
				if(val != current2){
					current2 = val;
					document.querySelector('form .btn[formaction*="browse"]').hidden = false;
					document.querySelector('form .btn[formaction*="edit"]').hidden = (!next.hasAttribute("data-editable")) || (next.getAttribute("data-editable") != "true");
					let previewarea = document.getElementById("previewarea");
					
					fetch(val).then(response => response.blob()).then(blob => {
						let iframe = document.createElement("iframe");
						if(lastBlob != null){
							URL.revokeObjectURL(lastBlob);
						}
						lastBlob = URL.createObjectURL(blob);
						iframe.setAttribute("src", `/assets/pdfjs/web/viewer.html?file=${lastBlob}`);
						previewarea.innerHTML = "";
						previewarea.appendChild(iframe);
					});
				}
				
			}
		}, 0);
	});
	
	document.querySelector('[data-name="page-prev"]').addEventListener("mousedown", e => {
		let page = document.querySelector('[data-name="files"] input[name="page"]:checked');
		if(page.previousElementSibling != null){
			page.previousElementSibling.checked = true;
		}
	});
	document.querySelector('[data-name="page-next"]').addEventListener("mousedown", e => {
		let page = document.querySelector('[data-name="files"] input[name="page"]:checked');
		if(page.nextElementSibling != null){
			page.nextElementSibling.checked = true;
		}
	});
	
	
	
	
	
	const additionalStyle = document.getElementById("additionalStyle");
	const styleSheet = additionalStyle.sheet;
	let n = styleSheet.cssRules.length;
	let mainContainer = document.getElementById("mainContainer");
	let rect = mainContainer.getBoundingClientRect();
	styleSheet.insertRule(`#mainContainer{
		height: calc(100vh - ${rect.y + window.pageYOffset}px - 1.5rem);
	}`, n++);
});
{/literal}</script>
{/block}

{block name="body"}
<form id="searchformdata" action="{url action="listItem"}" method="POST">
{html_hiddens data=$smarty.post}
</form>
<form action="{url action="list"}" method="POST" class="" target="_blank">
	<div class="grid1">
		<div>クライアント名</div><div>：</div><div data-name="client"></div><div></div>
		<div>商材名</div><div>：</div><div data-name="product_name"></div><div></div>
	</div>
	<div id="mainContainer" class="d-flex">
		<div id="mainlist"></div>
		<div id="previewContainer">
			<div id="previewarea">
			プレビュー
			</div>
			<div>
				<div id="pager">
					<button type="button" class="btn btn-sm btn-info bi bi-arrow-left-short" data-name="page-prev"></button>
					<div class="d-contents" data-name="files">
						<input type="radio" class="btn btn-sm btn-light" name="page" checked />
					</div>
					<button type="button" class="btn btn-sm btn-info bi bi-arrow-right-short" data-name="page-next"></button>
				</div>
			</div>
			<div class="grid1">
				<div>提案年月</div><div>：</div><div data-name="modified_date"></div><div></div>
				<div>ターゲット</div><div>：</div><div data-name="targets"></div><div></div>
				<div>媒体</div><div>：</div><div data-name="medias"></div><div></div>
				<div>タグ検索キーワード</div><div>：</div><div data-name="keyword"></div><div></div>
			</div>
			<div id="submitBtnArea" class="d-flex justify-content-center gap-md">
				<button type="submit" class="btn btn-outline-success rounded-pill" formaction="{url action="browse"}" hidden>閲覧</button>
				<button type="submit" class="btn btn-outline-success rounded-pill{if not $smarty.session["User.role"]|in_array:["admin", "entry"]} d-none{/if}" formaction="{url action="edit"}" hidden>編集</button>
			</div>
		</div>
	</div>
		
</form>
{/block}