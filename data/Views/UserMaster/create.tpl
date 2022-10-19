{block name="title"}
<nav class="navbar navbar-light bg-light">
	<h2 class="container-fluid">ユーザー</h2>
</nav>
{/block}

{block name="scripts" append}
<script type="text/javascript" src="/assets/common/form.js"></script>
<script type="text/javascript">var url = "{url action="index"}";</script>
<script type="text/javascript" src="/assets/common/master-form.js"></script>
{/block}


{block name="body"}
<form action="{url action="regist"}" method="POST" class="container-fluid row" data-master="ユーザー">
	<label for="e{counter skip=0}" class="col-12 form-label">ユーザー名<span class="badge bg-danger">必須</span></label>
	<div class="col-12 col-md-6 col-lg-5">
		<input type="text" name="username" id="e{counter skip=1}" class="form-control" placeholder="入力してください" />
		<div class="invalid-feedback"></div>
	</div>
	
	<label for="e{counter skip=0}" class="col-12 mt-5 form-label">メールアドレス<span class="badge bg-danger">必須</span></label>
	<div class="col-12 col-md-6 col-lg-5">
		<input type="mail" name="email" id="e{counter skip=1}" class="form-control" placeholder="入力してください" />
		<div class="invalid-feedback"></div>
	</div>
	
	<label for="e{counter skip=0}" class="col-12 mt-5 form-label">パスワード<span class="badge bg-danger">必須</span></label>
	<div class="col-12 col-md-6 col-lg-5">
		<input type="text" name="password" id="e{counter skip=1}" class="form-control" placeholder="入力してください" />
		<div class="invalid-feedback"></div>
	</div>
	
	<label for="e{counter skip=0}" class="col-12 mt-5 form-label">所属部署名<span class="badge bg-danger">必須</span></label>
	<div class="col-12 col-md-6 col-lg-5">
		<input type="text" name="department" id="e{counter skip=1}" class="form-select" placeholder="選択" />
		<div class="invalid-feedback"></div>
	</div>
	
	<label for="e{counter skip=0}" class="col-12 mt-5 form-label">権限グループ<span class="badge bg-danger">必須</span></label>
	<div class="col-12 col-md-6 col-lg-5">
		<select name="role" id="e{counter skip=1}" class="form-select">
			<option value="" selected hidden>選択</option>
			<option value=""></option>
			<option value="admin">{role code="admin"}</option>
			<option value="entry">{role code="entry"}</option>
			<option value="browse">{role code="browse"}</option>
		</select>
		<div class="invalid-feedback"></div>
	</div>
	
	<div>
		<div data-master-name=""></div>
		<div class="mt-5 invalid-feedback"></div>
	</div>
	
	<div class="col-12 mt-5 text-center">
		<button type="submit" class="btn btn-success rounded-pill w-25 d-inline-flex"><div class="flex-grow-1"></div>編集保存<div class="flex-grow-1"></div></button>
	</div>
</form>
{/block}