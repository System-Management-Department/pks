{block name="title"}
<nav class="navbar navbar-light bg-light">
	<h2 class="container-fluid justify-content-start gap-5">
		<div>媒体マスター</div>
		<a class="btn btn-sm btn-success rounded-pill" href="{url action="create"}">新規登録</a>
	</h2>
</nav>
{/block}

{block name="styles" append}
<style type="text/css">{literal}
#mainlist{
	overflow-y: auto;
}
#headergrid,#datagrid{
	display: grid;
	grid-template-columns: auto 1fr 9fr;
	grid-auto-rows: auto;
}
#headergrid{
	position: sticky;
	top: 0;
	background: white;
	border: 1px solid darkgray;
}
#headergrid *{
	padding: 10px;
}
#datagrid{
	border-left: 1px solid darkgray;
	border-right: 1px solid darkgray;
	border-bottom: 1px solid darkgray;
}
#datagrid .gridrow{
	display: none;
}
#datagrid .gridrow.odd{
	--row-color: lightgray;
}
#datagrid .gridrow.even{
	--row-color: white;
}
#datagrid .gridrow:hover{
	--row-color: yellow;
}
#datagrid .griddata{
	background: var(--row-color);
	padding: 10px;
}
#datagrid .griddata:first-child{
	grid-column: 1;
}
{/literal}</style>
{/block}

{block name="scripts" append}
<script type="text/javascript">{literal}
document.addEventListener("DOMContentLoaded", function(){
	const additionalStyle = document.getElementById("additionalStyle");
	const styleSheet = additionalStyle.sheet;
	let n = styleSheet.cssRules.length;
	let mainlist = document.getElementById("mainlist");
	let rect = mainlist.getBoundingClientRect();
	styleSheet.insertRule(`#mainlist{
		height: calc(100vh - ${rect.y + window.pageYOffset}px - 1.5rem);
	}`, n++);
	
	let filter = n;
	styleSheet.insertRule(`#datagrid .gridrow[data-filter]{
		display: contents;
	}`, n++);
	document.getElementById("filter").addEventListener("input", e => {
		let value = CSS.escape(e.currentTarget.value);
		let attr = (value == "") ? "data-filter" : `data-filter*="${value}"`;
		let selector = `#datagrid .gridrow[${attr}]`;
		styleSheet.cssRules[filter].selectorText = selector;
		Array.prototype.forEach.call(document.querySelectorAll(selector), (e, i) => {
			let odd = (i % 2) == 0;
			e.classList.add(odd ? "odd" : "even");
			e.classList.remove(odd ? "even" : "odd");
		});
	});
});
{/literal}</script>
{/block}

{block name="body"}
<form id="search" action="{url}" method="POST" class="container-fluid row justify-content-between">
	<div class="col-12 col-md-6 col-lg-4">
		<select class="form-select">
			<option hidden selected>一括操作選択</option>
		</select>
	</div>
	<div class="col-12 col-md-6 col-lg-4">
		<input id="filter" class="form-control" placeholder="媒体コード、媒体名称" />
	</div>
</form>
<div class="pt-5">
	<div id="mainlist">
		<div id="headergrid">
			<div><input type="checkbox" /></div>
			<div>No</div>
			<div>媒体名称</div>
		</div>
		<div id="datagrid">
		{foreach from=$medias item="media" name="loop"}
			<div class="gridrow {if ($smarty.foreach.loop.index % 2) eq 0}odd{else}even{/if}" data-filter="{$media.id}&#0;{$media.name}">
				<div class="griddata"><input type="checkbox" /></div>
				<div class="griddata">{$media.id}</div>
				<div class="griddata">{$media.name}</div>
			</div>
		{/foreach}
		</div>
	</div>
</div>
{/block}