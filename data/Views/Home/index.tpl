{block name="title"}
<nav class="navbar navbar-light bg-light">
	<h2 class="container-fluid">ホーム</h2>
</nav>
{/block}

{block name="body"}
<div class="row">
	<div class="col-12 col-md-6 col-lg-5">
		<div class="card h-100">
			<div class="card-header"><i class="bi bi-search"></i>過去事例検索</div>
			<div class="card-body d-flex flex-column justify-content-between">
				<div>過去、クライアントに提案した資料を検索・閲覧・編集することができます。</div>
				<div class="mt-4"><a href="{url controller="Member" action="index"}" class="btn btn-success">検索画面へ</a></div>
			</div>
		</div>
	</div>
	<div class="col-12 col-md-6 col-lg-5 mt-5 mt-md-0">
		<div class="card h-100">
			<div class="card-header"><i class="bi bi-pencil-square"></i>提案資料新規登録</div>
			<div class="card-body d-flex flex-column justify-content-between">
				<div>クライアントに提案済みの資料を登録します。</div>
				<div class="mt-4"><a href="{url controller="Member" action="create"}" class="btn btn-success">登録画面へ</a></div>
			</div>
		</div>
	</div>
	<div class="col-12 col-md-6 col-lg-5 mt-5">
		<div class="card h-100">
			<div class="card-header"><i class="bi bi-gear-wide"></i>マスタ管理</div>
			<div class="card-body d-flex flex-column justify-content-between">
				<div>各種マスタの管理をします。</div>
				<div class="mt-4"><a href="{url action="master"}" class="btn btn-success">マスタ管理へ</a></div>
			</div>
		</div>
	</div>
</div>
{/block}