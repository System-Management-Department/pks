{block name="title"}
<nav class="navbar navbar-light bg-light">
	<h2 class="container-fluid px-4 justify-content-start gap-5">
		<div>ターゲットマスター</div>
		<a class="btn btn-sm btn-success" href="{url action="create"}">新規追加</a>
	</h2>
</nav>
{/block}

{include file="../Shared/_function_master_style.tpl"}
{block name="styles" append}
{call name="shared_masterStyle" columns="1fr 9fr 80px 80px"}
{/block}

{block name="scripts" append}
<script type="text/javascript" src="/assets/common/master-list.js"></script>
{/block}

{block name="body"}
<form id="search" action="{url}" method="POST" class="d-flex gap-xn">
	<div class="flex-grow-1"></div>
	<a href="{url controller="Master" action="download" id="targets"}" class="btn btn-light" download="targets.csv"><i class="bi bi-download"></i>エクスポート</a>
	<label class="btn btn-light"><input type="file" formaction="{url controller="Master" action="upload" id="targets"}" accept="text/csv" /><i class="bi bi-upload"></i>インポート</label>
	<div class="input-group" id="filter">
		<input class="form-control" placeholder="ターゲットコード、ターゲット名称" autocomplete="off" />
		<button type="button" class="btn btn-success">ターゲットを検索</button>
	</div>
</form>
<div class="pt-4">
	<div id="mainlist">
		<div id="headergrid">
			<div>No</div>
			<div>ターゲット名称</div>
			<div></div>
			<div></div>
		</div>
		<div id="datagrid">
		{foreach from=$targets item="target" name="loop"}
			<div class="gridrow {if ($smarty.foreach.loop.index % 2) eq 0}odd{else}even{/if}" data-filter="{$target.id|escape:"html"}&#0;{$target.name|escape:"html"}">
				<div class="griddata">{$target.id|escape:"html"}</div>
				<div class="griddata">{$target.name|escape:"html"}</div>
				<div class="griddata"><a href="{url action="edit" id=$target.id}" class="fst-normal text-decoration-none text-primary">編集</a></div>
				<div class="griddata"><span class="fst-normal text-decoration-none text-danger" data-bs-toggle="modal" data-bs-target="#deleteModal" data-id="{$target.id|escape:"html"}">削除</span></div>
			</div>
		{/foreach}
		</div>
	</div>
</div>
{/block}

{include file="../Shared/_function_delete_modal.tpl"}
{block name="dialogs" append}
{call name="shared_deleteModal" title="ターゲットマスター"}
{/block}