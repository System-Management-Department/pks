{block name="title"}
<nav class="navbar navbar-light bg-light">
	<h2 class="container-fluid justify-content-start gap-5">
		<div>クライアントマスター</div>
		<a class="btn btn-sm btn-success rounded-pill" href="{url action="create"}">新規登録</a>
	</h2>
</nav>
{/block}

{include file="../Shared/_function_master_style.tpl"}
{block name="styles" append}
{call name="shared_masterStyle" columns="1fr 3fr 2fr 2fr 3fr 3fr 80px 80px"}
{/block}


{block name="scripts" append}
<script type="text/javascript" src="/assets/common/master-list.js"></script>
{/block}

{block name="body"}
<form id="search" action="{url}" method="POST" class="container-fluid row justify-content-between">
	<div class="col-12 col-md-6 col-lg-4">
	</div>
	<div class="col-12 col-md-6 col-lg-4">
		<input id="filter" class="form-control" placeholder="クライアントコード、クライアント名称" />
	</div>
</form>
<div class="pt-5">
	<div id="mainlist">
		<div id="headergrid">
			<div>No</div>
			<div>クライアント名称</div>
			<div>郵便番号</div>
			<div>都道府県</div>
			<div>市区町村・番地</div>
			<div>建物名・号室</div>
			<div></div>
			<div></div>
		</div>
		<div id="datagrid">
		{foreach from=$clients item="client" name="loop"}
			<div class="gridrow {if ($smarty.foreach.loop.index % 2) eq 0}odd{else}even{/if}" data-filter="{$client.id|escape:"html"}&#0;{$client.name|escape:"html"}">
				<div class="griddata">{$client.id|escape:"html"}</div>
				<div class="griddata">{$client.name|escape:"html"}</div>
				<div class="griddata">{$client.zip|escape:"html"}</div>
				<div class="griddata">{$client.address1|escape:"html"}</div>
				<div class="griddata">{$client.address2|escape:"html"}</div>
				<div class="griddata">{$client.address3|escape:"html"}</div>
				<div class="griddata"><a href="{url action="edit" id=$client.id}" class="btn btn-success">編集</a></div>
				<div class="griddata"><span class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#deleteModal" data-id="{$client.id|escape:"html"}">削除</span></div>
			</div>
		{/foreach}
		</div>
	</div>
</div>
{/block}

{include file="../Shared/_function_delete_modal.tpl"}
{block name="dialogs" append}
{call name="shared_deleteModal" title="クライアントマスター"}
{/block}