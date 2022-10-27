<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
{block name="styles"}
<link rel="stylesheet" type="text/css" href="/assets/bootstrap/css/bootstrap.min.css" />
<link rel="stylesheet" type="text/css" href="/assets/bootstrap/font/bootstrap-icons.css" />
<style id="additionalStyle">
	#mainGrid{
		display: grid;
		grid-template-columns: auto 1fr;
		grid-template-rows: auto auto 1fr;
		grid-auto-flow: column;
		position: fixed;
		top: 0;
		bottom: 0;
		left: 0;
		right: 0;
		height: auto;
		width: auto;
		margin: 0;
		padding: 0;
	}
	#sidebarToggle{
		display: contents;
	}
	.sidebar-section{
		display: contents;
		--sidebar-width: 12rem;
	}
	#sidebarToggle:checked~.sidebar-section{
		--sidebar-width: 3rem;
	}
	label[for="sidebarToggle"],#sidebar{
		white-space: nowrap;
		width: var(--sidebar-width);
		transition: width 0.5s;
		overflow: hidden;
		overflow-y: auto;
	}
	#sidebar .bi::before,.card-header .bi::before{
		width: 26px;
		font-size: 18px;
	}
	.grid-rowspan-2{
		grid-row-end: span 2;
	}
	.grid-colspan-2{
		grid-column-end: span 2;
	}
</style>
{/block}
{block name="scripts"}
<script type="text/javascript" src="/assets/bootstrap/js/bootstrap.min.js"></script>
<script type="text/javascript">{literal}
class Storage{
	static getToast(){
		return new Promise((resolve, reject) => {
			let openRequest = indexedDB.open("Storage", 1);
			let onSuccess = e => {
				let result = e.currentTarget.result;
				if(result == null){
					reject(null);
				}else{
					resolve(result);
				}
			};
			openRequest.addEventListener("error", reject);
			openRequest.addEventListener("upgradeneeded", e => {
				Storage.init(openRequest.result);
			});
			openRequest.addEventListener("success", e => {
				let db = openRequest.result;
				let transaction = db.transaction("map", "readonly");
				let map = transaction.objectStore("map");
				let request = map.get("Toast");
				request.addEventListener("success", onSuccess);
			});
			
		});
	}
	static pushToast(header, value){
		return new Promise((resolve, reject) => {
			let openRequest = indexedDB.open("Storage", 1);
			let onSuccess = e => {
				resolve(null);
			};
			openRequest.addEventListener("error", reject);
			openRequest.addEventListener("upgradeneeded", e => {
				Storage.init(openRequest.result);
			});
			openRequest.addEventListener("success", e => {
				let db = openRequest.result;
				let transaction = db.transaction("map", "readwrite");
				let map = transaction.objectStore("map");
				let request = map.put({key: "Toast", header: header, value: value});
				request.addEventListener("success", onSuccess);
			});
			
		});
	}
	static removeToast(){
		return new Promise((resolve, reject) => {
			let openRequest = indexedDB.open("Storage", 1);
			let onSuccess = e => {
				resolve(null);
			};
			openRequest.addEventListener("error", reject);
			openRequest.addEventListener("upgradeneeded", e => {
				Storage.init(openRequest.result);
			});
			openRequest.addEventListener("success", e => {
				let db = openRequest.result;
				let transaction = db.transaction("map", "readwrite");
				let map = transaction.objectStore("map");
				let request = map.delete("Toast");
				request.addEventListener("success", onSuccess);
			});
			
		});
	}
	static init(db){
		if(!db.objectStoreNames.contains("map")){
			db.createObjectStore("map", {keyPath: "key"});
		}
	}
}
document.addEventListener("DOMContentLoaded", function(){
	Storage.getToast().then(messages => {
		let container = document.querySelector('.toast-container');
		let option = {
			animation: true,
			autohide: false,
			delay: 1000
		};
		for(let message of messages.value){
			let bg = "bg-success";
			let toast = document.createElement("div");
			let header = document.createElement("div");
			let body = document.createElement("div");
			let title = document.createElement("strong");
			if(message[1] == 1){
				bg = "bg-warning";
			}else if(message[1] == 2){
				bg = "bg-danger";
			}
			toast.setAttribute("class", `toast show ${bg}`);
			header.setAttribute("class", "toast-header");
			body.setAttribute("class", "toast-body text-white");
			title.setAttribute("class", "me-auto");
			body.textContent = message[0];
			title.textContent = messages.header;
			header.appendChild(title);
			header.insertAdjacentHTML("beforeend", '<button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>');
			toast.appendChild(header);
			toast.appendChild(body);
			container.appendChild(toast);
			new bootstrap.Toast(toast, option);
		}
		Storage.removeToast();
	}).catch(() => {});
});
setInterval(() => {
	let prev = localStorage.getItem("session");
	let now = Date.now();
	if((prev == null) || (now - prev) >= 60000){
		localStorage.setItem("session", now);
		fetch({/literal}"{url controller="Online" action="update"}"{literal}).then(response => response.json()).then(json =>{
			
		});
	}
}, 60000);
{/literal}</script>
{/block}
</head>
<body>
	<div id="mainGrid">
		<input type="checkbox" id="sidebarToggle" tabindex="-1" />
		<section class="sidebar-section">
			<label for="sidebarToggle" class="bg-dark text-white text-end px-3 py-1">
				<i class="bi bi-list"></i>
			</label>
			<nav id="sidebar" class="grid-rowspan-2 bg-dark text-white sidebar px-3">
				<div class="py-2">提案書管理システム</div>
				<ul class="nav flex-column">
					<li class="nav-item">
						<a class="nav-link text-white active" href="{url controller="Home" action="index"}">
							<span class="ml-2"><i class="bi bi-house-door"></i>ホーム</span>
						</a>
					</li>
					<li class="nav-item">
						<a class="nav-link text-white" href="{url controller="Member" action="index"}">
							<span class="ml-2"><i class="bi bi-search"></i>過去事例検索画面</span>
						</a>
					</li>
					{if $smarty.session["User.role"]|in_array:["admin", "entry"]}
					<li class="nav-item">
						<a class="nav-link text-white" href="{url controller="Member" action="create"}">
							<span class="ml-2"><i class="bi bi-pencil-square"></i>提案資料新規登録</span>
						</a>
					</li>
					{/if}
					{if $smarty.session["User.role"] eq "admin"}
					<li class="nav-item">
						<span class="nav-link text-white" data-bs-toggle="collapse" data-bs-target="#components-collapse" aria-expanded="true" aria-current="true"><i class="bi bi-gear-wide"></i>マスタ管理</span>
						<div class="collapse show" id="components-collapse">
							<ul class="ms-3 list-unstyled small">
								<li><a class="nav-link text-white py-1" href="{url controller="UserMaster" action="index"}">ユーザー</a></li>
								<li><a class="nav-link text-white py-1" href="{url controller="ClientMaster" action="index"}">クライアントマスター</a></li>
								<li><a class="nav-link text-white py-1" href="{url controller="CategoryMaster" action="index"}">カテゴリマスター</a></li>
								<li><a class="nav-link text-white py-1" href="{url controller="TargetMaster" action="index"}">ターゲットマスター</a></li>
								<li><a class="nav-link text-white py-1" href="{url controller="MediaMaster" action="index"}">媒体マスター</a></li>
							</ul>
						</div>
					</li>
					<li class="nav-item">
						<a class="nav-link text-white" href="{url controller="Log" action="index"}">
							<span class="ml-2"><i class="bi bi-hourglass"></i>操作履歴</span>
						</a>
					</li>
					{/if}
				</ul>
			</nav>
		</section>
		<div class="bg-dark text-white text-end px-3 py-1">
			<a href="{url controller="Default" action="logout"}" class="text-white">Logout&ensp;<i class="bi bi-box-arrow-right"></i></a>
		</div>
		<div>{block name="title"}{/block}</div>
		<div class="overflow-auto px-4 py-4">
			{block name="body"}{/block}
		</div>
	</div>
	<div style="position:fixed;top:0;bottom:0;right:0;left:0;width:auto;height:auto;margin:0;padding:0;display:grid;grid-template:1fr auto 1fr/1fr auto 1fr;visibility:hidden;">
		<div class="toast-container" style="grid-column:2;grid-row:2;visibility:visible;"></div>
	</div>
	{block name="dialogs"}{javascript_notice}{/block}
</body>
</html>