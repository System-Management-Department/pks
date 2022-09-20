{block name="title"}
<nav class="navbar navbar-light bg-light">
	<h2 class="container-fluid">過去事例検索画面</h2>
</nav>
{/block}

{block name="styles" append}{/block}

{block name="body"}
<form action="{url action="list"}" method="POST" class="container-fluid row">
	<label for="e{counter skip=0}" class="col-12 form-label">クライアント名</label>
	<div class="col-12 col-md-6 col-lg-5">
		<select name="client" id="e{counter skip=1}" class="form-control">
			<option value="" disabled selected>入力してください</option>
			{foreach from=$clients key="code" item="data"}
			<option value="{$code}">{$data}</option>
			{/foreach}
		</select>
	</div>
	
	<label for="e{counter skip=0}" class="col-12 mt-5 form-label">クライアント業種</label>
	<div class="col-12">
		{foreach from=$categories key="code" item="data"}
		<label><input type="checkbox" name="categories[]" id="e{counter skip=1}" value="{$code}" />{$data}</label>
		{/foreach}
	</div>
	
	<label for="e{counter skip=0}" class="col-12 mt-5 form-label">検索キーワード</label>
	{for $foo=1 to 6}
	<div class="col-12 col-md-6 col-lg-5 mb-1"><input type="text" name="keyword[]" id="e{counter skip=1}" class="form-control" placeholder="入力してください" /></div>
	{/for}
	
	<input type="hidden" name="lastdata" value="" />
	<div class="col-12 mt-5 text-center"><button type="submit" class="btn btn-success rounded-pill w-25 d-inline-flex"><div class="flex-grow-1"></div>検<div class="flex-grow-1"></div>索<div class="flex-grow-1"></div></button></div>
</form>
{/block}
