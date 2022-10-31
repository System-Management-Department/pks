{block name="title"}
<nav class="navbar navbar-light bg-light">
	<h2 class="container-fluid px-4">マスタ管理</h2>
</nav>
{/block}

{block name="body"}
<div class="row">
	<div class="col-12 col-md-6 col-lg-5">
		<div class="card h-100">
			<div class="card-header"><i class="bi bi-person-plus-fill"></i>ユーザー</div>
			<div class="card-body d-flex flex-column justify-content-between">
				<div>ユーザーを登録することで、サービスを利用できるユーザー追加し権限をつけることができます。</div>
				<div class="mt-4 d-flex flex-wrap gap-3">
					<a href="{url controller="UserMaster" action="index"}" class="btn btn-success">ユーザー登録</a>
				</div>
			</div>
		</div>
	</div>
	<div class="col-12 col-md-6 col-lg-5 mt-5 mt-md-0">
		<div class="card h-100">
			<div class="card-header"><i class="bi bi-building"></i>クライアントマスター</div>
			<div class="card-body d-flex flex-column justify-content-between">
				<div>クライアントを登録します。</div>
				<div class="mt-4 d-flex flex-wrap gap-3">
					<a href="{url controller="ClientMaster" action="index"}" class="btn btn-success">クライアントマスター登録</a>
				</div>
			</div>
		</div>
	</div>
	<div class="col-12 col-md-6 col-lg-5 mt-5">
		<div class="card h-100">
			<div class="card-header"><i class="bi bi-card-list"></i>カテゴリマスター</div>
			<div class="card-body d-flex flex-column justify-content-between">
				<div>提案商材のカテゴリを登録することができます。</div>
				<div class="mt-4 d-flex flex-wrap gap-3">
					<a href="{url controller="CategoryMaster" action="index"}" class="btn btn-success">カテゴリマスター登録</a>
				</div>
			</div>
		</div>
	</div>
	<div class="col-12 col-md-6 col-lg-5 mt-5">
		<div class="card h-100">
			<div class="card-header"><i class="bi bi-person-check-fill"></i>ターゲットマスター</div>
			<div class="card-body d-flex flex-column justify-content-between">
				<div>ターゲットを登録することができます。</div>
				<div class="mt-4 d-flex flex-wrap gap-3">
					<a href="{url controller="TargetMaster" action="index"}" class="btn btn-success">ターゲットマスター登録</a>
				</div>
			</div>
		</div>
	</div>
	<div class="col-12 col-md-6 col-lg-5 mt-5">
		<div class="card h-100">
			<div class="card-header"><i class="bi bi-badge-ad-fill"></i>媒体マスター</div>
			<div class="card-body d-flex flex-column justify-content-between">
				<div>媒体を登録することができます。</div>
				<div class="mt-4 d-flex flex-wrap gap-3">
					<a href="{url controller="MediaMaster" action="index"}" class="btn btn-success">媒体マスター登録</a>
				</div>
			</div>
		</div>
	</div>
</div>
{/block}