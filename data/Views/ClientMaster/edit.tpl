{block name="title"}
<nav class="navbar navbar-light bg-light">
	<h2 class="container-fluid">クライアントマスター</h2>
</nav>
{/block}

{block name="scripts" append}
<script type="text/javascript" src="/assets/common/form.js"></script>
<script type="text/javascript" src="/assets/common/master-form.js"></script>
<script type="text/javascript">var url = "{url action="index"}";</script>
{/block}


{block name="body"}
<form action="{url action="update" id=$data.id}" method="POST" class="container-fluid row" data-master="クライアントマスター">
	<label for="e{counter skip=0}" class="col-12 form-label">クライアント名称（必須）</label>
	<div class="col-12 col-lg-10">
		<input type="text" name="name" id="e{counter skip=1}" class="form-control" placeholder="入力してください" value="{$data.name}" />
		<div class="invalid-feedback"></div>
	</div>
	
	<label for="e{counter skip=0}" class="col-12 mt-5 form-label">郵便番号（必須）</label>
	<div class="col-12 col-md-6 col-lg-5">
		<input type="text" name="zip" id="e{counter skip=1}" class="form-control" placeholder="入力してください" value="{$data.zip}">
		<div class="invalid-feedback"></div>
	</div>
	
	<label for="e{counter skip=0}" class="col-12 mt-5 form-label">都道府県（必須）</label>
	<div class="col-12 col-md-6 col-lg-5">
		<input type="text" name="address1" id="e{counter skip=1}" class="form-select" placeholder="選択" value="{$data.address1}">
		<div class="invalid-feedback"></div>
	</div>
	
	<label for="e{counter skip=0}" class="col-12 mt-5 form-label">市区町村・番地（必須）</label>
	<div class="col-12 col-lg-10">
		<input type="text" name="address2" id="e{counter skip=1}" class="form-control" placeholder="入力してください" value="{$data.address2}">
		<div class="invalid-feedback"></div>
	</div>
	
	<label for="e{counter skip=0}" class="col-12 mt-5 form-label">建物名・号室（任意）</label>
	<div class="col-12 col-lg-10">
		<input type="text" name="address3" id="e{counter skip=1}" class="form-control" placeholder="入力してください" value="{$data.address3}">
		<div class="invalid-feedback"></div>
	</div>
	
	<div class="row mt-5">
		<div class="col-12 col-md-6 col-lg-5">
			<label for="e{counter skip=0}" class="col-12">電話番号（必須）</label>
			<div>
				<input name="phone" type="text" id="e{counter skip=1}" class="form-control" placeholder="入力してください" value="{$data.phone}" />
				<div class="invalid-feedback"></div>
			</div>
			
			<label for="e{counter skip=0}" class="col-12 mt-5">請求書締日（必須）</label>
			<div>
				<input name="close" type="text" id="e{counter skip=1}" class="form-control" placeholder="入力してください" value="{$data.close}" />
				<div class="invalid-feedback"></div>
			</div>
		</div>
		
		<div class="col-12 col-md-6 col-lg-5 mt-5 mt-md-0">
			<label for="e{counter skip=0}" class="col-12">FAX番号（任意）</label>
			<div>
				<input name="fax" type="text" id="e{counter skip=1}" class="form-control" placeholder="入力してください" value="{$data.fax}" />
				<div class="invalid-feedback"></div>
			</div>
			
			<label for="e{counter skip=0}" class="col-12 mt-5">入金日（必須）</label>
			<div>
				<input name="payment" type="text" id="e{counter skip=1}" class="form-control" placeholder="入力してください" value="{$data.payment}" />
				<div class="invalid-feedback"></div>
			</div>
		</div>
	</div>
	
	<label for="e{counter skip=0}" class="col-12 mt-5 form-label">入金サイクル（必須）</label>
	<div class="col-12 col-md-6 col-lg-5">
		<input type="text" name="cycle" id="e{counter skip=1}" class="form-control" placeholder="入力してください" value="{$data.cycle}">
		<div class="invalid-feedback"></div>
	</div>
	
	<div>
		<div data-master-name=""></div>
		<div class="mt-5 invalid-feedback"></div>
	</div>
	
	<div class="col-12 mt-5 text-center">
		<button type="submit" class="btn btn-success rounded-pill w-25 d-inline-flex"><div class="flex-grow-1"></div>登録・更新<div class="flex-grow-1"></div></button>
	</div>
</form>
{/block}