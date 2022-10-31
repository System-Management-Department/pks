{block name="title"}
<nav class="navbar navbar-light bg-light">
	<h2 class="container-fluid px-4">ユーザー</h2>
</nav>
{/block}

{block name="styles" append}
<link rel="stylesheet" type="text/css" href="/assets/common/form.css" />
{/block}

{block name="scripts" append}
<script type="text/javascript" src="/assets/common/form.js"></script>
<script type="text/javascript">var url = "{url action="index"}";</script>
<script type="text/javascript" src="/assets/common/master-form.js"></script>
{/block}


{block name="body"}
<form action="{url action="regist"}" method="POST" class="form-grid-12" data-master="ユーザー">
	<div class="grid-colspan-12 grid-colreset">
		<label for="e{counter skip=0}" class="form-label d-flex gap-2">ユーザー名<span class="badge bg-danger">必須</span></label>
		<input type="text" name="username" id="e{counter skip=1}" class="form-control" placeholder="入力してください" autocomplete="off" />
		<div class="invalid-feedback"></div>
	</div>
	<div class="grid-colspan-12 grid-colreset">
		<label for="e{counter skip=0}" class="form-label d-flex gap-2">メールアドレス<span class="badge bg-danger">必須</span></label>
		<input type="mail" name="email" id="e{counter skip=1}" class="form-control" placeholder="入力してください" autocomplete="off" />
		<div class="invalid-feedback"></div>
	</div>
	<div class="grid-colspan-12 grid-colreset">
		<label for="e{counter skip=0}" class="form-label d-flex gap-2">パスワード<span class="badge bg-danger">必須</span></label>
		<input type="text" name="password" id="e{counter skip=1}" class="form-control" placeholder="入力してください" autocomplete="off" />
		<div class="invalid-feedback"></div>
	</div>
	<div class="grid-colspan-12 grid-colreset">
		<label for="e{counter skip=0}" class="form-label d-flex gap-2">所属部署名<span class="badge bg-danger">必須</span></label>
		<input type="text" name="department" id="e{counter skip=1}" class="form-select" placeholder="選択" autocomplete="off" />
		<div class="invalid-feedback"></div>
	</div>
	<div class="grid-colspan-12 grid-colreset">
		<label for="e{counter skip=0}" class="form-label d-flex gap-2">権限グループ<span class="badge bg-danger">必須</span></label>
		<select name="role" id="e{counter skip=1}" class="form-select">
			<option value="" selected hidden>選択</option>
			<option value=""></option>
			<option value="admin">{role code="admin"}</option>
			<option value="entry">{role code="entry"}</option>
			<option value="browse">{role code="browse"}</option>
		</select>
		<div class="invalid-feedback"></div>
		<div>
			<div data-master-name=""></div>
			<div class="mt-5 invalid-feedback"></div>
		</div>
	</div>
	<div class="grid-colspan-12 text-center">
		<button type="submit" class="btn btn-success rounded-pill w-25 d-inline-flex"><div class="flex-grow-1"></div>編集保存<div class="flex-grow-1"></div></button>
	</div>
</form>
{/block}