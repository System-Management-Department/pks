{block name="title"}
<nav class="navbar navbar-light bg-light">
	<h2 class="container-fluid">過去事例検索画面</h2>
</nav>
{/block}

{block name="styles" append}
<style type="text/css">{literal}
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
	display: inline-block;
	width: 100px;
	height: 100px;
	background-size: contain;
	margin: 3px;
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
	outline: 4px solid blue;
	filter: none;
}
#mainlist .thumbnail a{
	display: none;
}
#previewarea iframe{
	height: 100%;
	width: 100%;
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
					Array.prototype.forEach.call(document.querySelectorAll('form .btn[formaction]:disabled'), btn => btn.disabled = false);
					let previewarea = document.getElementById("previewarea");
					
					fetch(next.querySelector('a[data-type^="application/pdf"]').getAttribute("href")).then(response => response.blob()).then(blob => {
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
	
	
	
	const additionalStyle = document.getElementById("additionalStyle");
	const styleSheet = additionalStyle.sheet;
	let n = styleSheet.cssRules.length;
	let previewContainer = document.getElementById("previewContainer");
	let rect = previewContainer.getBoundingClientRect();
	styleSheet.insertRule(`#previewarea{
		height: calc(100vh - ${rect.y + window.pageYOffset + 60}px);
	}`, n++);
});
{/literal}</script>
{/block}

{block name="body"}
<form id="searchformdata" action="{url action="listItem"}" method="POST">
{html_hiddens data=$smarty.post}
</form>
<form action="{url action="list"}" method="POST" class="container-fluid row" target="_blank">
	<div class="col-12">
		クライアント名：
	</div>
	<div class="col-12">
		商材名：
	</div>
	<div class="col-6" id="mainlist"></div>
	<div class="col-6" id="previewContainer">
		<div class="position-sticky top-0">
			<div id="previewarea">
			プレビュー
			</div>
			<div class="row">
				<button type="submit" class="btn btn-outline-success rounded-pill col-6" formaction="{url action="browse"}" disabled>閲覧</button>
				<button type="submit" class="btn btn-outline-success rounded-pill col-6" formaction="{url action="edit"}" disabled>編集</button>
			</div>
		</div>
	</div>
</form>
{/block}