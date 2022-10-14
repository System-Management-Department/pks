{block name="title"}
<nav class="navbar navbar-light bg-light">
	<h2 class="container-fluid">カテゴリーマスター</h2>
</nav>
{/block}

{block name="scripts" append}
<script type="text/javascript">var url = "{url action="index"}";</script>
<script type="text/javascript" src="/assets/common/master-form.js"></script>
{/block}

{block name="body"}
<form action="{url action="update" id=$data.id}" method="POST" class="container-fluid row" data-master="カテゴリーマスター">
	{if !($data.large_id|is_null)}
	<label class="col-12 form-label">大分類</label>
	<div class="col-12 col-md-6 col-lg-5 mb-1">
		<div class="input-group">
			<div class="form-select">{$categoryName[$data.large_id].name}</div>
			<a href="{url id=$data.large_id}" class="btn btn-success">編集</a>
		</div>
	</div>
	{/if}
	
	{if !($data.middle_id|is_null)}
	<label class="mt-5 col-12 form-label">中分類</label>
	<div class="col-12 col-md-6 col-lg-5 mb-1">
		<div class="input-group">
			<div class="form-select">{$categoryName[$data.middle_id].name}</div>
			<a href="{url id=$data.middle_id}" class="btn btn-success">編集</a>
		</div>
	</div>
	{/if}
	
	<label for="e{counter skip=0}" class="{if !($data.large_id|is_null)}mt-5 {/if}col-12 form-label">{if $data.large_id|is_null}大{elseif $data.middle_id|is_null}中{else}小{/if}分類（必須）</label>
	<div class="col-12 col-md-6 col-lg-5 mb-1">
		<input type="text" name="name" id="e{counter skip=1}" class="form-control" placeholder="入力してください" value="{$data.name}" />
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