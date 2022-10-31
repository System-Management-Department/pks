{block name="title"}
<nav class="navbar navbar-light bg-light">
	<h2 class="container-fluid px-4">マスタ管理</h2>
</nav>
{/block}

{block name="scripts" append}
<script type="text/javascript">{literal}
document.addEventListener("DOMContentLoaded", function(){
	let uploadFiles = document.querySelectorAll('input[type="file"][formaction]');
	let upload = e => {
		let input = e.currentTarget;
		if(input.files.length == 1){
			let formData = new FormData();
			formData.append("data", input.files[0], input.files[0].name);
			fetch(input.getAttribute("formaction"), {
				method: "POST",
				body: formData
			}).then(res => res.json()).then(json => {
				Storage.pushToast("マスター管理", json.messages);
				location.reload();
			});
		}
	};
	for(let input of uploadFiles){
		input.addEventListener("change", upload);
	}
});
{/literal}</script>
{/block}

{block name="body"}
<div class="row">
	<div class="col-12 col-md-6 col-lg-5">
		<div class="card h-100">
			<div class="card-header">ユーザー</div>
			<div class="card-body d-flex flex-column justify-content-between">
				<div></div>
				<div class="mt-4 d-flex flex-wrap gap-3">
					<a href="{url controller="UserMaster" action="index"}" class="btn btn-success">ユーザーへ</a>
					<a href="{url controller="Master" action="download" id="users"}" class="btn btn-success" download="users.csv">ダウンロード</a>
					<input type="file" formaction="{url controller="Master" action="upload" id="users"}" accept="text/csv" class="btn btn-success" />
				</div>
			</div>
		</div>
	</div>
	<div class="col-12 col-md-6 col-lg-5 mt-5 mt-md-0">
		<div class="card h-100">
			<div class="card-header">クライアントマスター</div>
			<div class="card-body d-flex flex-column justify-content-between">
				<div></div>
				<div class="mt-4 d-flex flex-wrap gap-3">
					<a href="{url controller="ClientMaster" action="index"}" class="btn btn-success">クライアントマスターへ</a>
					<a href="{url controller="Master" action="download" id="clients"}" class="btn btn-success" download="clients.csv">ダウンロード</a>
					<input type="file" formaction="{url controller="Master" action="upload" id="clients"}" accept="text/csv" class="btn btn-success" />
				</div>
			</div>
		</div>
	</div>
	<div class="col-12 col-md-6 col-lg-5 mt-5">
		<div class="card h-100">
			<div class="card-header">カテゴリマスター</div>
			<div class="card-body d-flex flex-column justify-content-between">
				<div></div>
				<div class="mt-4 d-flex flex-wrap gap-3">
					<a href="{url controller="CategoryMaster" action="index"}" class="btn btn-success">カテゴリマスターへ</a>
					<a href="{url controller="Master" action="download" id="categories"}" class="btn btn-success" download="categories.csv">ダウンロード</a>
					<input type="file" formaction="{url controller="Master" action="upload" id="categories"}" accept="text/csv" class="btn btn-success" />
				</div>
			</div>
		</div>
	</div>
	<div class="col-12 col-md-6 col-lg-5 mt-5">
		<div class="card h-100">
			<div class="card-header">ターゲットマスター</div>
			<div class="card-body d-flex flex-column justify-content-between">
				<div></div>
				<div class="mt-4 d-flex flex-wrap gap-3">
					<a href="{url controller="TargetMaster" action="index"}" class="btn btn-success">ターゲットマスターへ</a>
					<a href="{url controller="Master" action="download" id="targets"}" class="btn btn-success" download="targets.csv">ダウンロード</a>
					<input type="file" formaction="{url controller="Master" action="upload" id="targets"}" accept="text/csv" class="btn btn-success" />
				</div>
			</div>
		</div>
	</div>
	<div class="col-12 col-md-6 col-lg-5 mt-5">
		<div class="card h-100">
			<div class="card-header">媒体マスター</div>
			<div class="card-body d-flex flex-column justify-content-between">
				<div></div>
				<div class="mt-4 d-flex flex-wrap gap-3">
					<a href="{url controller="MediaMaster" action="index"}" class="btn btn-success">媒体マスターへ</a>
					<a href="{url controller="Master" action="download" id="medias"}" class="btn btn-success" download="medias.csv">ダウンロード</a>
					<input type="file" formaction="{url controller="Master" action="upload" id="medias"}" accept="text/csv" class="btn btn-success" />
				</div>
			</div>
		</div>
	</div>
</div>
{/block}