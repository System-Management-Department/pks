{block name="title"}
<nav class="navbar navbar-light bg-light">
	<h2 class="container-fluid">カテゴリーマスター</h2>
</nav>
{/block}

{block name="scripts" append}
<script type="text/javascript">var url = "{url action="index"}";</script>
<script type="text/javascript" src="/assets/common/master-form.js"></script>
<script type="text/javascript">{literal}
document.addEventListener("DOMContentLoaded", function(){
	let large = document.querySelector('form input[name="l"]');
	let middle = document.querySelector('form input[name="m"]');
	large.addEventListener("change", e => {
		middle.setAttribute("list", `d${large.value}`);
	});
});
{/literal}</script>
{/block}


{block name="body"}
<form action="{url action="regist"}" method="POST" class="container-fluid row" data-master="カテゴリーマスター">
	<datalist id="d">
	{foreach from=$categoriesL item="category1"}
		<option value="{$category1.name}"></option>
	{/foreach}
	</datalist>
	{foreach from=$categoriesL item="category1"}
	<datalist id="d{$category1.name}">
		{foreach from=$categoriesM[$category1.id] item="category2"}
		<option value="{$category2.name}"></option>
		{/foreach}
	</datalist>
	{/foreach}
	
	<label for="e{counter skip=0}" class="col-12 form-label">大分類（必須）</label>
	<div class="col-12 col-md-6 col-lg-5 mb-1">
		<input type="text" name="l" id="e{counter skip=1}" class="form-select" placeholder="入力してください" list="d" />
		<div class="invalid-feedback"></div>
	</div>
	
	<label for="e{counter skip=0}" class="mt-5 col-12 form-label">中分類（必須）</label>
	<div class="col-12 col-md-6 col-lg-5 mb-1">
		<input type="text" name="m" id="e{counter skip=1}" class="form-select" placeholder="入力してください" />
		<div class="invalid-feedback"></div>
	</div>
	
	<label for="e{counter skip=0}" class="mt-5 col-12 form-label">小分類（必須）</label>
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