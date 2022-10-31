{block name="title"}
<nav class="navbar navbar-light bg-light">
	<h2 class="container-fluid px-4">クライアントマスター</h2>
</nav>
{/block}

{block name="styles" append}
<link rel="stylesheet" type="text/css" href="/assets/common/form.css" />
{/block}

{block name="scripts" append}
<script type="text/javascript" src="/assets/common/form.js"></script>
<script type="text/javascript" src="/assets/common/master-form.js"></script>
<script type="text/javascript">var url = "{url action="index"}";</script>
{/block}


{block name="body"}
<form action="{url action="regist"}" method="POST" class="form-grid-12" data-master="クライアントマスター">
	<div class="grid-colspan-12 grid-colreset">
		<label for="e{counter skip=0}" class="form-label d-flex gap-2">クライアント名称<span class="badge bg-danger">必須</span></label>
		<input type="text" name="name" id="e{counter skip=1}" class="form-control" placeholder="入力してください" autocomplete="off" />
		<div class="invalid-feedback"></div>
	</div>
	<div class="grid-colspan-6 grid-colreset">
		<label for="e{counter skip=0}" class="form-label d-flex gap-2">郵便番号<span class="badge bg-danger">必須</span></label>
		<input type="text" name="zip" id="e{counter skip=1}" class="form-control" placeholder="入力してください" autocomplete="off" />
		<div class="invalid-feedback"></div>
	</div>
	<div class="grid-colspan-6 grid-colreset">
		<label for="e{counter skip=0}" class="form-label d-flex gap-2">都道府県<span class="badge bg-danger">必須</span></label>
		<input type="text" name="address1" id="e{counter skip=1}" class="form-select" placeholder="選択" autocomplete="off" />
		<div class="invalid-feedback"></div>
	</div>
	<div class="grid-colspan-12 grid-colreset">
		<label for="e{counter skip=0}" class="form-label d-flex gap-2">市区町村・番地<span class="badge bg-danger">必須</span></label>
		<input type="text" name="address2" id="e{counter skip=1}" class="form-control" placeholder="入力してください" autocomplete="off" />
		<div class="invalid-feedback"></div>
	</div>
	<div class="grid-colspan-12 grid-colreset">
		<label for="e{counter skip=0}" class="form-label d-flex gap-2">建物名・号室<span class="badge bg-secondary">任意</span></label>
		<input type="text" name="address3" id="e{counter skip=1}" class="form-control" placeholder="入力してください" autocomplete="off" />
		<div class="invalid-feedback"></div>
	</div>
	<div class="grid-colspan-6">
		<label for="e{counter skip=0}" class="form-label d-flex gap-2">電話番号<span class="badge bg-danger">必須</span></label>
		<input name="phone" type="text" id="e{counter skip=1}" class="form-control" placeholder="入力してください" autocomplete="off" />
		<div class="invalid-feedback"></div>
	</div>
	<div class="grid-colspan-6 grid-colreset">
		<label for="e{counter skip=0}" class="form-label d-flex gap-2">請求書締日<span class="badge bg-danger">必須</span></label>
		<input name="close" type="text" id="e{counter skip=1}" class="form-control" placeholder="入力してください" autocomplete="off" />
		<div class="invalid-feedback"></div>
	</div>
	<div class="grid-colspan-6">
		<label for="e{counter skip=0}" class="form-label d-flex gap-2">FAX番号<span class="badge bg-secondary">任意</span></label>
		<input name="fax" type="text" id="e{counter skip=1}" class="form-control" placeholder="入力してください" autocomplete="off" />
		<div class="invalid-feedback"></div>
	</div>
	<div class="grid-colspan-6 grid-colreset">
		<label for="e{counter skip=0}" class="form-label d-flex gap-2">入金日<span class="badge bg-danger">必須</span></label>
		<input name="payment" type="text" id="e{counter skip=1}" class="form-control" placeholder="入力してください" autocomplete="off" />
		<div class="invalid-feedback"></div>
	</div>
	<div class="grid-colspan-12 grid-colreset">
		<label for="e{counter skip=0}" class="form-label d-flex gap-2">入金サイクル<span class="badge bg-danger">必須</span></label>
		<input type="text" name="cycle" id="e{counter skip=1}" class="form-control" placeholder="入力してください" autocomplete="off" />
		<div class="invalid-feedback"></div>
		<div>
			<div data-master-name=""></div>
			<div class="mt-5 invalid-feedback"></div>
		</div>
	</div>
	<div class="grid-colspan-12 text-center">
		<button type="submit" class="btn btn-success rounded-pill w-25 d-inline-flex"><div class="flex-grow-1"></div>登録・更新<div class="flex-grow-1"></div></button>
	</div>
</form>
{/block}