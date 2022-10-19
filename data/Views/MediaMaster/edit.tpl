{block name="title"}
<nav class="navbar navbar-light bg-light">
	<h2 class="container-fluid">媒体マスター</h2>
</nav>
{/block}

{block name="scripts" append}
<script type="text/javascript" src="/assets/common/form.js"></script>
<script type="text/javascript">var url = "{url action="index"}";</script>
<script type="text/javascript" src="/assets/common/master-form.js"></script>
{/block}


{block name="body"}
<form action="{url action="update" id=$data.id}" method="POST" class="container-fluid row" data-master="媒体マスター">
	<label for="e{counter skip=0}" class="col-12 form-label">媒体名称<span class="badge bg-danger">必須</span></label>
	<div class="col-12 col-md-6 col-lg-5 mb-1">
		<input type="text" name="name" id="e{counter skip=1}" class="form-control" placeholder="入力してください" value="{$data.name|escape:"html"}" />
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