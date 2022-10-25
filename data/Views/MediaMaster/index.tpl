{block name="title"}
<nav class="navbar navbar-light bg-light">
	<h2 class="container-fluid justify-content-start gap-5">
		<div>媒体マスター</div>
		<a class="btn btn-sm btn-success rounded-pill" href="{url action="create"}">新規登録</a>
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
<form id="search" action="{url}" method="POST" class="container-fluid row justify-content-between">
	<div class="col-12 col-md-6 col-lg-4">
	</div>
	<div class="col-12 col-md-6 col-lg-4">
		<input id="filter" class="form-control" placeholder="媒体コード、媒体名称" autocomplete="off" />
	</div>
</form>
<div class="pt-5">
	<div id="mainlist">
		<div id="headergrid">
			<div>No</div>
			<div>媒体名称</div>
			<div></div>
			<div></div>
		</div>
		<div id="datagrid">
		{foreach from=$medias item="media" name="loop"}
			<div class="gridrow {if ($smarty.foreach.loop.index % 2) eq 0}odd{else}even{/if}" data-filter="{$media.id|escape:"html"}&#0;{$media.name|escape:"html"}">
				<div class="griddata">{$media.id|escape:"html"}</div>
				<div class="griddata">{$media.name|escape:"html"}</div>
				<div class="griddata"><a href="{url action="edit" id=$media.id}" class="fst-normal text-decoration-none text-primary">編集</a></div>
				<div class="griddata"><span class="fst-normal text-decoration-none text-danger" data-bs-toggle="modal" data-bs-target="#deleteModal" data-id="{$media.id|escape:"html"}">削除</span></div>
			</div>
		{/foreach}
		</div>
	</div>
</div>
{/block}

{include file="../Shared/_function_delete_modal.tpl"}
{block name="dialogs" append}
{call name="shared_deleteModal" title="媒体マスター"}
{/block}