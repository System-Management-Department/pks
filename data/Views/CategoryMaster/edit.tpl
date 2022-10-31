{block name="title"}
<nav class="navbar navbar-light bg-light">
	<h2 class="container-fluid px-4">カテゴリーマスター</h2>
</nav>
{/block}

{block name="styles" append}
<link rel="stylesheet" type="text/css" href="/assets/common/form.css" />
{/block}

{block name="scripts" append}
<script type="text/javascript">var url = "{url action="index"}";</script>
<script type="text/javascript" src="/assets/common/master-form.js"></script>
{/block}

{block name="body"}
<form action="{url action="update" id=$data.id}" method="POST" class="form-grid-12" data-master="カテゴリーマスター">
	{if !($data.large_id|is_null)}
	<div class="grid-colspan-6 grid-colreset">
		<label class="form-label d-flex gap-2">大分類</label>
		<div class="input-group">
			<div class="form-select">{$categoryName[$data.large_id].name|escape:"html"}</div>
			<a href="{url id=$data.large_id}" class="btn btn-success">編集</a>
		</div>
	</div>
	{/if}
	{if !($data.middle_id|is_null)}
	<div class="grid-colspan-6 grid-colreset">
		<label class="form-label d-flex gap-2">中分類</label>
		<div class="input-group">
			<div class="form-select">{$categoryName[$data.middle_id].name|escape:"html"}</div>
			<a href="{url id=$data.middle_id}" class="btn btn-success">編集</a>
		</div>
	</div>
	{/if}
	<div class="grid-colspan-6 grid-colreset">
		<label for="e{counter skip=0}" class="form-label d-flex gap-2">{if $data.large_id|is_null}大{elseif $data.middle_id|is_null}中{else}小{/if}分類<span class="badge bg-danger">必須</span></label>
		<input type="text" name="name" id="e{counter skip=1}" class="form-control" placeholder="入力してください" value="{$data.name|escape:"html"}" autocomplete="off" />
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