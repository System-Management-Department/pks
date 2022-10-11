<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
{block name="styles"}
<link rel="stylesheet" type="text/css" href="/assets/bootstrap/css/bootstrap.min.css" />
<link rel="stylesheet" type="text/css" href="/assets/bootstrap/font/bootstrap-icons.css" />
<link rel="stylesheet" type="text/css" href="/assets/fontawesome/css/solid.min.css" />
<style id="additionalStyle"></style>
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
		let container = document.querySelector('#mainContents .toast-container');
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
	const additionalStyle = document.getElementById("additionalStyle");
	const styleSheet = additionalStyle.sheet;
	let n = styleSheet.cssRules.length;
	
	styleSheet.insertRule(`nav.navbar.position-sticky{
		z-index: 1000;
	}`, n++);
	let main = document.getElementById("mainContents");
	let rect = main.getBoundingClientRect();
	styleSheet.insertRule(`#mainRow{
		height: calc(100vh - ${rect.y + window.pageYOffset}px);
		overflow: auto;
		--main-top: ${rect.y + window.pageYOffset}px;
	}`, n++);
	styleSheet.insertRule(`#sidebar>.position-sticky{
		z-index: 1000;
	}`, n++);
	
	styleSheet.insertRule(`#mainContents .toast-container{
		z-index: 1000;
	}`, n++);
});
{/literal}</script>
{/block}
</head>
<body>
	<nav class="navbar navbar-light position-sticky top-0 bg-dark text-white py-1">
		<div class="d-flex col-3 col-lg-2 flex-wrap flex-md-nowrap justify-content-end px-3">
			<i class="bi bi-list"></i>
		</div>
		<div class="d-flex col-9 col-lg-10 align-items-center justify-content-end px-3">
			<a href="{url controller="Default" action="logout"}" class="text-white">Logout<i class="bi bi-box-arrow-right"></i></a>
		</div>
	</nav>
	<div class="container-fluid">
		<div id="mainRow" class="row">
			<nav id="sidebar" class="col-md-3 col-lg-2 d-md-block bg-dark text-white sidebar collapse">
				<div class="position-sticky top-0">
					提案書管理システム
					<ul class="nav flex-column">
						<li class="nav-item">
							<a class="nav-link text-white active" href="{url controller="Member" action="index"}">
								<span class="ml-2"><i class="bi bi-house-door"></i>ホーム</span>
							</a>
						</li>
						<li class="nav-item">
							<a class="nav-link text-white" href="{url controller="Member" action="index"}">
								<span class="ml-2"><i class="bi bi-search"></i>過去事例検索画面</span>
							</a>
						</li>
						<li class="nav-item">
							<a class="nav-link text-white" href="{url controller="Member" action="create"}">
								<span class="ml-2"><i class="bi bi-pencil-square"></i>提案資料新規登録</span>
							</a>
						</li>
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
					</ul>
				</div>
			</nav>
			<main id="mainContents" class="col-md-9 ml-sm-auto col-lg-10 px-0 position-relative">
				<div class="toast-container position-absolute top-0 end-0 p-3"></div>
				{block name="title"}{/block}
				<div class="px-md-4 py-4">
					{block name="body"}{/block}
				</div>
			</main>
		</div>
	</div>
	{block name="dialogs"}{javascript_notice}{/block}
</body>
</html>