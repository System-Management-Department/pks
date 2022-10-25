{block name="title"}
<nav class="navbar navbar-light bg-light">
	<h2 class="container-fluid justify-content-start gap-5">
		<div>カテゴリマスター</div>
		<a class="btn btn-sm btn-success rounded-pill" href="{url action="create"}">新規登録</a>
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
<form id="search" action="{url}" method="POST" class="container-fluid row justify-content-between">
	<div class="col-12 col-md-6 col-lg-4">
	</div>
	<div class="col-12 col-md-6 col-lg-4">
		<input id="filter" class="form-control" placeholder="カテゴリコード、カテゴリ名称" autocomplete="off" />
	</div>
</form>
<div class="pt-5">
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
				<div class="griddata"><a href="{url action="edit" id=$category.id}" class="btn btn-success">編集</a></div>
				<div class="griddata"><span class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#deleteModal" data-id="{$category.id|escape:"html"}">削除</span></div>
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