{block name="title"}
<nav class="navbar navbar-light bg-light">
	<h2 class="container-fluid">マスタ管理</h2>
</nav>
{/block}

{block name="body"}
<div class="row">
	<div class="col-12 col-md-6 col-lg-5">
		<div class="card h-100">
			<div class="card-header">ユーザー</div>
			<div class="card-body d-flex flex-column justify-content-between">
				<div></div>
				<div class="mt-4"><a href="{url controller="UserMaster" action="index"}" class="btn btn-success">ユーザーへ</a></div>
			</div>
		</div>
	</div>
	<div class="col-12 col-md-6 col-lg-5 mt-5 mt-md-0">
		<div class="card h-100">
			<div class="card-header">クライアントマスター</div>
			<div class="card-body d-flex flex-column justify-content-between">
				<div></div>
				<div class="mt-4"><a href="{url controller="ClientMaster" action="index"}" class="btn btn-success">クライアントマスターへ</a></div>
			</div>
		</div>
	</div>
	<div class="col-12 col-md-6 col-lg-5 mt-5">
		<div class="card h-100">
			<div class="card-header">カテゴリマスター</div>
			<div class="card-body d-flex flex-column justify-content-between">
				<div></div>
				<div class="mt-4"><a href="{url controller="CategoryMaster" action="master"}" class="btn btn-success">カテゴリマスターへ</a></div>
			</div>
		</div>
	</div>
	<div class="col-12 col-md-6 col-lg-5 mt-5">
		<div class="card h-100">
			<div class="card-header">ターゲットマスター</div>
			<div class="card-body d-flex flex-column justify-content-between">
				<div></div>
				<div class="mt-4"><a href="{url controller="TargetMaster" action="master"}" class="btn btn-success">ターゲットマスターへ</a></div>
			</div>
		</div>
	</div>
	<div class="col-12 col-md-6 col-lg-5 mt-5">
		<div class="card h-100">
			<div class="card-header">媒体マスター</div>
			<div class="card-body d-flex flex-column justify-content-between">
				<div></div>
				<div class="mt-4"><a href="{url controller="MediaMaster" action="master"}" class="btn btn-success">媒体マスターへ</a></div>
			</div>
		</div>
	</div>
</div>
{/block}