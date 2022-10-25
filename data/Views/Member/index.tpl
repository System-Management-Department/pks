{block name="title"}
<nav class="navbar navbar-light bg-light">
	<h2 class="container-fluid">過去事例検索画面</h2>
</nav>
{/block}

{block name="styles" append}
<link rel="stylesheet" href="/assets/flatpickr/flatpickr.min.css">
{/block}

{block name="scripts" append}
<script src="/assets/flatpickr/flatpickr.min.js"></script>
<script src="/assets/common/form.js"></script>
<script type="text/javascript">{literal}
document.addEventListener("DOMContentLoaded", function(){
	flatpickr('input[name="modified_date"]');
	let categories = {
		l: document.querySelector('[data-categories="l"] select'),
		m: [...document.querySelectorAll('[data-categories="m"] select')],
		s: [...document.querySelectorAll('[data-categories="s"] select')]
	};
	let changeMEvent = e => {
		let select = e.currentTarget;
		for(let category of categories.s){
			let display = category.getAttribute("data-parent") == select.value;
			document.querySelector(`[data-categories="s"]${display ? "" : " fieldset"}`).appendChild(category);
		}
	};
	let changeLEvent = e => {
		let select = e.currentTarget;
		let nextSelect = null;
		for(let category of categories.m){
			let display = category.getAttribute("data-parent") == select.value;
			document.querySelector(`[data-categories="m"]${display ? "" : " fieldset"}`).appendChild(category);
			if(display){
				nextSelect = category;
			}
		}
		if(nextSelect != null){
			changeMEvent({currentTarget: nextSelect});
		}
	};
	categories.l.addEventListener("change", changeLEvent);
	for(let category of categories.m){
		category.addEventListener("change", changeMEvent);
	}
});
{/literal}</script>
{/block}

{block name="body"}
<form action="{url action="list"}" method="POST" class="container-fluid row">
	<div class="col-12 col-md-6 col-lg-5">
		<label for="e{counter skip=0}" class="form-label">提案年月日</label>
		<input name="modified_date" type="text" id="e{counter skip=1}" class="form-control bg-white" placeholder="日付を選択してください" autocomplete="off" />
	</div>
	
	<div class="mt-4"></div>
	
	<div class="col-12 col-md-6 col-lg-5">
		<label for="e{counter skip=0}" class="col-12">クライアント名</label>
		<select name="client" id="e{counter skip=1}" class="form-select">
			<option value="" selected hidden>クライアントを選択</option>
			<option value=""></option>
			{foreach from=$clients key="code" item="data"}
			<option value="{$code|escape:"html"}">{$data.name|escape:"html"}</option>
			{/foreach}
		</select>
	</div>
	
	<div class="col-12 col-md-6 col-lg-5 mt-4 mt-md-0">
		<label for="e{counter skip=0}" class="col-12">商材名</label>
		<input name="product_name" type="text" id="e{counter skip=1}" class="form-control" placeholder="入力してください" autocomplete="off" />
	</div>
	
	<label for="e{counter skip=0}" class="col-12 mt-4 form-label">クライアント　カテゴリー</label>

	<div class="col-12 col-md-4" data-categories="l">
		<select name="categories[]" class="form-select" id="e{counter skip=1}">
			<option value="" selected hidden>大項目</option>
			<option value=""></option>
			{foreach from=$categoriesL key="code" item="data"}
				<option value="{$code|escape:"html"}">{$data.name|escape:"html"}</option>
			{/foreach}
		</select>
	</div>
	<div class="col-12 col-md-4 mt-1 mt-md-0" data-categories="m">
		<select name="categories[]" class="form-select" data-parent="">
			<option value="" selected hidden>中項目</option>
			<option value=""></option>
		</select>
		<fieldset disabled hidden>
			{foreach from=$categoriesM key="parent" item="categories"}
			<select name="categories[]" class="form-select" data-parent="{$parent|escape:"html"}">
				<option value="" selected hidden>中項目</option>
				<option value=""></option>
				{foreach from=$categories key="code" item="data"}
					<option value="{$code|escape:"html"}">{$data.name|escape:"html"}</option>
				{/foreach}
			</select>
			{/foreach}
		</fieldset>
	</div>
	<div class="col-12 col-md-4 mt-1 mt-md-0" data-categories="s">
		<select name="categories[]" class="form-select" data-parent="">
			<option value="" selected hidden>小項目</option>
			<option value=""></option>
		</select>
		<fieldset disabled hidden>
			{foreach from=$categoriesS key="parent" item="categories"}
			<select name="categories[]" class="form-select" data-parent="{$parent|escape:"html"}">
				<option value="" selected hidden>小項目</option>
				<option value=""></option>
				{foreach from=$categories key="code" item="data"}
					<option value="{$code|escape:"html"}">{$data.name|escape:"html"}</option>
				{/foreach}
			</select>
			{/foreach}
		</fieldset>
	</div>
	
	<div class="col-12 mt-4">
		<label class="form-label">ターゲット</label>
		<div>
			{foreach from=$targets key="code" item="data"}
			<div class="form-check form-check-inline">
				<input type="checkbox" name="targets[]" id="e{counter skip=0}" value="{$code|escape:"html"}" class="form-check-input" /><label for="e{counter skip=1}" class="form-check-label">{$data.name|escape:"html"}</label>
			</div>
			{/foreach}
		</div>
	</div>
	
	<div class="col-12 mt-4">
		<label class="form-label">媒体</label>
		<div>
			{foreach from=$medias key="code" item="data"}
			<div class="form-check form-check-inline">
				<input type="checkbox" name="medias[]" id="e{counter skip=0}" value="{$code|escape:"html"}" class="form-check-input" /><label for="e{counter skip=1}" class="form-check-label">{$data.name|escape:"html"}</label>
			</div>
			{/foreach}
		</div>
	</div>
	
	<label class="col-12 mt-4 form-label">関係者スタッフ名</label>
	<div class="col-12 col-md-6 col-lg-5">
		<label for="e{counter skip=0}">営業担当者名</label>
		<input name="sales_staff" type="text" id="e{counter skip=1}" class="form-control" placeholder="入力してください" autocomplete="off" />
	</div>
	<div class="col-12 col-md-6 col-lg-5 mt-3 mt-md-0">
		<label for="e{counter skip=0}">プランナー</label>
		<input name="planner" type="text" id="e{counter skip=1}" class="form-control" placeholder="入力してください" autocomplete="off" />
	</div>
	<div class="col-12 col-md-6 col-lg-5 mt-3">
		<label for="e{counter skip=0}">コピーライター</label>
		<input name="copywriter" type="text" id="e{counter skip=1}" class="form-control" placeholder="入力してください" autocomplete="off" />
	</div>
	<div class="col-12 col-md-6 col-lg-5 mt-3">
		<label for="e{counter skip=0}">デザイナー</label>
		<input name="designer" type="text" id="e{counter skip=1}" class="form-control" placeholder="入力してください" autocomplete="off" />
	</div>
	
	<div class="col-12 col-lg-10 mt-4">
		<label for="e{counter skip=0}" class="form-label">提案内容／ポイント</label>
		<textarea name="content" id="e{counter skip=1}" class="form-control" rows="3" placeholder="入力してください"></textarea>
	</div>
	
	<label for="e{counter skip=0}" class="col-12 mt-4 form-label">タグ検索キーワード （成分名、オンパレ、タレント名など絞り込みやすい検索ワード）</label>
	{for $foo=1 to 6}
	<div class="col-12 col-md-6 col-lg-5 mb-1"><input type="text" name="keyword[]" id="e{counter skip=1}" class="form-control" placeholder="入力してください" autocomplete="off" /></div>
	{/for}
	
	<input type="hidden" name="lastdata" value="" />
	<div class="col-12 mt-4 text-center"><button type="submit" class="btn btn-success rounded-pill w-25 d-inline-flex"><div class="flex-grow-1"></div>検<div class="flex-grow-1"></div>索<div class="flex-grow-1"></div></button></div>
</form>
{/block}
