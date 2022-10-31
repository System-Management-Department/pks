{block name="title"}
<nav class="navbar navbar-light bg-light">
	<h2 class="container-fluid">新規登録</h2>
</nav>
{/block}

{block name="styles" append}
<link rel="stylesheet" type="text/css" href="/assets/flatpickr/flatpickr.min.css" />
<link rel="stylesheet" type="text/css" href="/assets/flatpickr/plugins/monthSelect/style.css" />
<link rel="stylesheet" type="text/css" href="/assets/common/form.css" />
<link rel="stylesheet" type="text/css" href="/assets/common/proposal-form.css" />
{/block}

{block name="scripts" append}
<script type="text/javascript" src="/assets/flatpickr/flatpickr.min.js"></script>
<script type="text/javascript" src="/assets/flatpickr/l10n/ja.js"></script>
<script type="text/javascript" src="/assets/flatpickr/plugins/monthSelect/index.js"></script>
<script type="text/javascript" src="/assets/pdfjs/build/pdf.js"></script>
<script type="text/javascript" src="/assets/common/form.js"></script>
<script type="text/javascript">var url = "{url action="index"}";</script>
<script type="text/javascript" src="/assets/common/proposal-form.js"></script>
{/block}

{block name="body"}
<form action="{url action="regist"}" method="POST" class="form-grid-12">
	<div class="grid-colspan-3 grid-colreset">
		<label for="e{counter skip=0}" class="form-label d-flex gap-2">提案年月<span class="badge bg-danger">必須</span></label>
		<input type="date" name="modified_date" id="e{counter skip=1}" class="form-control bg-white" placeholder="提案年月を選択" autocomplete="off" />
		<div class="invalid-feedback"></div>
	</div>
	<div class="grid-colspan-6">
		<label for="e{counter skip=0}" class="form-label d-flex gap-2">クライアント名<span class="badge bg-danger">必須</span></label>
		<select name="client" id="e{counter skip=1}" class="form-select">
			<option value="" selected hidden>クライアントを選択</option>
			<option value=""></option>
			{foreach from=$clients key="code" item="client"}
			<option value="{$code|escape:"html"}">{$client.name|escape:"html"}</option>
			{/foreach}
		</select>
		<div class="invalid-feedback"></div>
	</div>
	<div class="grid-colspan-6 grid-colreset">
		<label for="e{counter skip=0}" class="form-label d-flex gap-2">商材名<span class="badge bg-danger">必須</span></label>
		<input name="product_name" type="text" id="e{counter skip=1}" class="form-control" placeholder="入力してください" autocomplete="off" />
		<div class="invalid-feedback"></div>
	</div>
	<div class="grid-colspan-12 grid-colreset">
		<label for="e{counter skip=0}" class="form-label d-flex gap-2">クライアント　カテゴリー<span class="badge bg-danger">必須</span></label>
		<div class="form-grid-12">
			<div class="grid-colspan-4" data-categories="l">
				<select name="categories[]" class="form-select" id="e{counter skip=1}">
					<option value="" selected hidden>大項目</option>
					<option value=""></option>
					{foreach from=$categoriesL key="code" item="category"}
						<option value="{$code|escape:"html"}">{$category.name|escape:"html"}</option>
					{/foreach}
				</select>
				<div class="invalid-feedback"></div>
			</div>
			<div class="grid-colspan-4">
				<div data-categories="m">
					<select name="categories[]" class="form-select" data-parent="">
						<option value="" selected hidden>中項目</option>
						<option value=""></option>
					</select>
					<fieldset disabled hidden>
						{foreach from=$categoriesM key="parent" item="categories"}
						<select name="categories[]" class="form-select" data-parent="{$parent|escape:"html"}">
							<option value="" selected hidden>中項目</option>
							<option value=""></option>
							{foreach from=$categories key="code" item="category"}
								<option value="{$code|escape:"html"}">{$category.name|escape:"html"}</option>
							{/foreach}
						</select>
						{/foreach}
					</fieldset>
				</div>
				<div class="invalid-feedback"></div>
			</div>
			<div class="grid-colspan-4">
				<div data-categories="s">
					<select name="categories[]" class="form-select" data-parent="">
						<option value="" selected hidden>小項目</option>
						<option value=""></option>
					</select>
					<fieldset disabled hidden>
						{foreach from=$categoriesS key="parent" item="categories"}
						<select name="categories[]" class="form-select" data-parent="{$parent|escape:"html"}">
							<option value="" selected hidden>小項目</option>
							<option value=""></option>
							{foreach from=$categories key="code" item="category"}
								<option value="{$code|escape:"html"}">{$category.name|escape:"html"}</option>
							{/foreach}
						</select>
						{/foreach}
					</fieldset>
				</div>
				<div class="invalid-feedback"></div>
			</div>
		</div>
	</div>
	<div class="grid-colspan-12 grid-colreset">
		<label class="form-label d-flex gap-2">ターゲット<span class="badge bg-danger">必須</span></label>
		<div data-name="targets">
			{foreach from=$targets key="code" item="target"}
			<div class="form-check form-check-inline">
				<input type="checkbox" name="targets[]" id="e{counter skip=0}" value="{$code|escape:"html"}" class="form-check-input" /><label for="e{counter skip=1}" class="form-check-label">{$target.name|escape:"html"}</label>
			</div>
			{/foreach}
		</div>
		<div class="invalid-feedback"></div>
	</div>
	<div class="grid-colspan-12 grid-colreset">
		<label for="e{counter skip=0}" class="form-label d-flex gap-2">媒体<span class="badge bg-danger">必須</span></label>
		<div data-name="medias">
			{foreach from=$medias key="code" item="media"}
			<div class="form-check form-check-inline">
				<input type="checkbox" name="medias[]" id="e{counter skip=0}" value="{$code|escape:"html"}" class="form-check-input" /><label for="e{counter skip=1}" class="form-check-label">{$media.name|escape:"html"}</label>
			</div>
			{/foreach}
		</div>
		<div class="invalid-feedback"></div>
	</div>
	<div class="grid-colspan-12 grid-colreset">
		<label class="form-label d-flex gap-2">関係者スタッフ名<span class="badge bg-secondary">任意</span></label>
		<div class="form-grid-12 grid-row-gap-3">
			<div class="grid-colspan-6">
				<label for="e{counter skip=0}">営業担当者名</label>
				<input name="sales_staff" type="text" id="e{counter skip=1}" class="form-control" placeholder="入力してください" autocomplete="off" />
				<div class="invalid-feedback"></div>
			</div>
			<div class="grid-colspan-6">
				<label for="e{counter skip=0}">プランナー</label>
				<input name="planner" type="text" id="e{counter skip=1}" class="form-control" placeholder="入力してください" autocomplete="off" />
				<div class="invalid-feedback"></div>
			</div>
			<div class="grid-colspan-6">
				<label for="e{counter skip=0}">コピーライター</label>
				<input name="copywriter" type="text" id="e{counter skip=1}" class="form-control" placeholder="入力してください" autocomplete="off" />
				<div class="invalid-feedback"></div>
			</div>
			<div class="grid-colspan-6">
				<label for="e{counter skip=0}">デザイナー</label>
				<input name="designer" type="text" id="e{counter skip=1}" class="form-control" placeholder="入力してください" autocomplete="off" />
				<div class="invalid-feedback"></div>
			</div>
		</div>
	</div>
	<div class="grid-colspan-12 grid-colreset">
		<label for="e{counter skip=0}" class="form-label d-flex gap-2">提案内容／ポイント<span class="badge bg-danger">必須</span></label>
		<textarea name="content" id="e{counter skip=1}" class="form-control" rows="3" placeholder="入力してください"></textarea>
		<div class="invalid-feedback"></div>
	</div>
	<div class="grid-colspan-12 grid-colreset">
		<label for="e{counter skip=0}" class="form-label d-flex gap-2">タグ検索キーワード <span class="badge bg-danger">必須</span>（成分名、オンパレ、タレント名など絞り込みやすい検索ワード）</label>
		<div class="form-grid-12 grid-row-gap-2" data-name="keyword">
			{for $foo=0 to 5}
			<div class="grid-colspan-6"><input type="text" name="keyword[]" id="e{counter skip=1}" class="form-control" placeholder="入力してください" autocomplete="off" /></div>
			{/for}
		</div>
		<div class="invalid-feedback"></div>
	</div>
	<div class="grid-colspan-12 grid-colreset">
		<label for="e{counter skip=0}" class="form-label d-flex gap-2">メディアライブラリ（PDF）<span class="badge bg-danger">必須</span></label>
		<div class="d-flex flex-wrap gap-3" id="pdf">
			<div class="card mb-3 d-flex text-center card-select">ファイルを選択</div>
		</div>
		<div class="invalid-feedback"></div>
	</div>
	<div class="grid-colspan-12 grid-colreset">
		<label for="e{counter skip=0}" class="form-label">メディアライブラリ（PowerPoint、Keynote、Excelなど）<span class="badge bg-danger">必須</span></label>
		<div class="d-flex flex-wrap gap-3" id="vnd">
			<div class="card mb-3 d-flex text-center card-select">ファイルを選択</div>
		</div>
		<div class="invalid-feedback"></div>
		<div>
			<div data-name="files"></div>
			<div class="invalid-feedback"></div>
		</div>
	</div>
	<div class="grid-colspan-12 grid-colreset">
		<label for="e{counter skip=0}" class="form-label d-flex gap-2">説明録画<span class="badge bg-secondary">任意</span></label>
		<div>
			<button type="button" class="btn btn-outline-danger btn-rec d-inline-flex gap-xn"><i class="bi bi-camera-video-fill"></i>Rec</button>
			<button type="button" data-bs-toggle="modal" data-bs-target="#recModal" hidden></button>
		</div>
	</div>
	<div class="grid-colspan-12 d-flex justify-content-center gap-md">
		<a href="{url controller="Home" action="index"}" class="btn btn-secondary rounded-pill w-25 d-inline-flex"><div class="flex-grow-1"></div>キャンセル<div class="flex-grow-1"></div></a>
		<button type="submit" class="btn btn-success rounded-pill w-25 d-inline-flex"><div class="flex-grow-1"></div>編集保存<div class="flex-grow-1"></div></button>
	</div>
</form>
{/block}

{block name="dialogs" append}
<div class="modal fade" id="recModal" tabindex="-1">
	<div class="modal-dialog modal-lg modal-dialog-centered">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title" id="staticBackdropLabel">説明録画</h5>
				<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
			</div>
			<div class="modal-body" id="video"></div>
			<div class="modal-footer">
				<button type="button" class="btn btn-primary btn-rec2">録画</button>
				<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
			</div>
		</div>
	</div>
</div>
{/block}