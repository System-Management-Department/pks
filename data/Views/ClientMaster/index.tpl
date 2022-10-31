{block name="title"}
<nav class="navbar navbar-light bg-light">
	<h2 class="container-fluid px-4 justify-content-start gap-5">
		<div>クライアントマスター</div>
		<a class="btn btn-sm btn-success" href="{url action="create"}">新規追加</a>
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
<form id="search" action="{url}" method="POST" class="d-flex gap-xn">
	<div class="flex-grow-1"></div>
	<a href="{url controller="Master" action="download" id="clients"}" class="btn btn-light" download="clients.csv"><i class="bi bi-download"></i>エクスポート</a>
	<label class="btn btn-light"><input type="file" formaction="{url controller="Master" action="upload" id="clients"}" accept="text/csv" /><i class="bi bi-upload"></i>インポート</label>
	<div class="input-group" id="filter">
		<input class="form-control" placeholder="クライアントコード、クライアント名称" autocomplete="off" />
		<button type="button" class="btn btn-success">クライアントを検索</button>
	</div>
</form>
<div class="pt-4">
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
				<div class="griddata"><a href="{url action="edit" id=$client.id}" class="fst-normal text-decoration-none text-primary">編集</a></div>
				<div class="griddata"><span class="fst-normal text-decoration-none text-danger" data-bs-toggle="modal" data-bs-target="#deleteModal" data-id="{$client.id|escape:"html"}">削除</span></div>
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