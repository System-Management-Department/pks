{block name="title"}
<nav class="navbar navbar-light bg-light">
	<h2 class="container-fluid justify-content-start gap-5">
		<div>ユーザー</div>
		<a class="btn btn-sm btn-success rounded-pill" href="{url action="create"}">新規登録</a>
	</h2>
</nav>
{/block}

{include file="../Shared/_function_master_style.tpl"}
{block name="styles" append}
{call name="shared_masterStyle" columns="1fr 1fr 1fr 1fr 80px 80px"}
{/block}

{block name="scripts" append}
<script type="text/javascript" src="/assets/common/master-list.js"></script>
{/block}

{block name="body"}
<form id="search" action="{url}" method="POST" class="container-fluid row justify-content-between">
	<div class="col-12 col-md-6 col-lg-4">
	</div>
	<div class="col-12 col-md-6 col-lg-4">
		<input id="filter" class="form-control" placeholder="ユーザー名・メールアドレス" autocomplete="off" />
	</div>
</form>
<div class="pt-5">
	<div id="mainlist">
		<div id="headergrid">
			<div>ユーザー名</div>
			<div>メールアドレス</div>
			<div>所属部署名</div>
			<div>権限グループ</div>
			<div></div>
			<div></div>
		</div>
		<div id="datagrid">
		{foreach from=$users item="user" name="loop"}
			<div class="gridrow {if ($smarty.foreach.loop.index % 2) eq 0}odd{else}even{/if}" data-filter="{$user.username|escape:"html"}&#0;{$user.email|escape:"html"}">
				<div class="griddata">{$user.username|escape:"html"}</div>
				<div class="griddata">{$user.email|escape:"html"}</div>
				<div class="griddata">{$user.department|escape:"html"}</div>
				<div class="griddata">{role code=$user.role}</div>
				<div class="griddata">{if $smarty.session["User.id"] ne $user.id}<a href="{url action="edit" id=$user.id}" class="fst-normal text-decoration-none text-primary">編集</a>{/if}</div>
				<div class="griddata">{if $smarty.session["User.id"] ne $user.id}<span class="fst-normal text-decoration-none text-danger" data-bs-toggle="modal" data-bs-target="#deleteModal" data-id="{$user.id|escape:"html"}">削除</span>{/if}</div>
			</div>
		{/foreach}
		</div>
	</div>
</div>
{/block}

{include file="../Shared/_function_delete_modal.tpl"}
{block name="dialogs" append}
{call name="shared_deleteModal" title="ユーザー"}
{/block}