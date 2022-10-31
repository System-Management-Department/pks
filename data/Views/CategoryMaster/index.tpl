{block name="title"}
<nav class="navbar navbar-light bg-light">
	<h2 class="container-fluid px-4 justify-content-start gap-5">
		<div>カテゴリマスター</div>
		<a class="btn btn-sm btn-success" href="{url action="create"}">新規追加</a>
	</h2>
</nav>
{/block}

{include file="../Shared/_function_master_style.tpl"}
{block name="styles" append}
{call name="shared_masterStyle" columns="1fr 3fr 3fr 3fr 80px 80px"}
{/block}


{block name="scripts" append}
<script type="text/javascript" src="/assets/common/master-list.js"></script>
{/block}

{block name="body"}
<form id="search" action="{url}" method="POST" class="d-flex gap-xn">
	<div class="flex-grow-1"></div>
	<a href="{url controller="Master" action="download" id="categories"}" class="btn btn-light" download="categories.csv"><i class="bi bi-download"></i>エクスポート</a>
	<label class="btn btn-light"><input type="file" formaction="{url controller="Master" action="upload" id="categories"}" accept="text/csv" /><i class="bi bi-upload"></i>インポート</label>
	<div class="input-group" id="filter">
		<input class="form-control" placeholder="カテゴリコード、カテゴリ名称" autocomplete="off" />
		<button type="button" class="btn btn-success">カテゴリを検索</button>
	</div>
</form>
<div class="pt-4">
	<div id="mainlist">
		<div id="headergrid">
			<div>No</div>
			<div>大分類</div>
			<div>中分類</div>
			<div>小分類</div>
			<div></div>
			<div></div>
		</div>
		<div id="datagrid">
		{foreach from=$categories item="category" name="loop"}
			<div class="gridrow {if ($smarty.foreach.loop.index % 2) eq 0}odd{else}even{/if}" data-filter="{$category.id|escape:"html"}&#0;{$categoryName[$category.large_id|escape:"html"].name}&#0;{$categoryName[$category.middle_id].name|escape:"html"}&#0;{$category.name|escape:"html"}">
				<div class="griddata">{$category.id|escape:"html"}</div>
				<div class="griddata">{$categoryName[$category.large_id].name|escape:"html"}</div>
				<div class="griddata">{$categoryName[$category.middle_id].name|escape:"html"}</div>
				<div class="griddata">{$category.name|escape:"html"}</div>
				<div class="griddata"><a href="{url action="edit" id=$category.id}" class="fst-normal text-decoration-none text-primary">編集</a></div>
				<div class="griddata"><span class="fst-normal text-decoration-none text-danger" data-bs-toggle="modal" data-bs-target="#deleteModal" data-id="{$category.id|escape:"html"}">削除</span></div>
			</div>
		{/foreach}
		</div>
	</div>
</div>
{/block}

{include file="../Shared/_function_delete_modal.tpl"}
{block name="dialogs" append}
{call name="shared_deleteModal" title="カテゴリマスター"}
{/block}