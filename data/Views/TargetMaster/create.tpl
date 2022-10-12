{block name="title"}
<nav class="navbar navbar-light bg-light">
	<h2 class="container-fluid">ターゲットマスター</h2>
</nav>
{/block}

{block name="scripts" append}
<script type="text/javascript" src="/assets/common/form.js"></script>
<script type="text/javascript">var url = "{url action="index"}";</script>
<script type="text/javascript" src="/assets/common/master-form.js"></script>
{/block}


{block name="body"}
<form action="{url action="regist"}" method="POST" class="container-fluid row" data-master="ターゲットマスター">
	<label for="e{counter skip=0}" class="col-12 form-label">ターゲット名称（必須）</label>
	<div class="col-12 col-md-6 col-lg-5 mb-1">
		<input type="text" name="name" id="e{counter skip=1}" class="form-control" placeholder="入力してください" />
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