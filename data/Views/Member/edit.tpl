{block name="title"}
<nav class="navbar navbar-light bg-light">
	<h2 class="container-fluid">編集登録画面</h2>
</nav>
{/block}

{block name="styles" append}
<link rel="stylesheet" type="text/css" href="/assets/flatpickr/flatpickr.min.css" />
<link rel="stylesheet" type="text/css" href="/assets/common/proposal-form.css" />
{/block}

{block name="scripts" append}
<script type="text/javascript" src="/assets/flatpickr/flatpickr.min.js"></script>
<script type="text/javascript" src="/assets/pdfjs/build/pdf.js"></script>
<script type="text/javascript" src="/assets/common/form.js"></script>
<script type="text/javascript">var url = "{url action="index"}";</script>
<script type="text/javascript" src="/assets/common/proposal-form.js"></script>
{/block}

{block name="body"}
<form action="{url action="update" id=$data.id}" method="POST" class="container-fluid row">
	<label for="e{counter skip=0}" class="col-12 form-label">提案年月日（必須）</label>
	<div class="col-12 col-md-6 col-lg-5 mb-1">
		<input type="date" name="modified_date" id="e{counter skip=1}" class="form-control bg-white" placeholder="日付を選択してください" value="{$data.modified_date|escape:"html"}" />
		<div class="invalid-feedback"></div>
	</div>
	
	<div class="mt-5 row">
		<div class="col-12 col-md-6 col-lg-5">
			<label for="e{counter skip=0}" class="col-12">クライアント名（必須）</label>
			<div>
				<select name="client" id="e{counter skip=1}" class="form-select">
					<option value="" hidden>クライアントを選択</option>
					<option value=""></option>
					{foreach from=$clients key="code" item="client"}
					<option value="{$code|escape:"html"}"{if $code eq $data.client} selected{/if}>{$client.name|escape:"html"}</option>
					{/foreach}
				</select>
				<div class="invalid-feedback"></div>
			</div>
		</div>
		
		<div class="col-12 col-md-6 col-lg-5 mt-5 mt-md-0">
			<label for="e{counter skip=0}" class="col-12">商材名（必須）</label>
			<div>
				<input name="product_name" type="text" id="e{counter skip=1}" class="form-control" placeholder="入力してください" value="{$data.product_name|escape:"html"}" />
				<div class="invalid-feedback"></div>
			</div>
		</div>
	</div>
	
	<label for="e{counter skip=0}" class="col-12 mt-5 form-label">クライアント　カテゴリー（必須）</label>
	<div class="col-12 col-lg-10">
		<div class="row">
			<div class="col-12 col-md-4" data-categories="l">
				<select name="categories[]" class="form-select" id="e{counter skip=1}">
					<option value="" hidden>大項目</option>
					<option value=""></option>
					{foreach from=$categoriesL key="code" item="category"}
						<option value="{$code|escape:"html"}"{if $code eq $data.categories[0]} selected{/if}>{$category.name|escape:"html"}</option>
					{/foreach}
				</select>
				<div class="invalid-feedback"></div>
			</div>
			<div class="col-12 col-md-4 mt-1 mt-md-0">
				<div data-categories="m">
					<select name="categories[]" class="form-select" data-parent="">
						<option value="" selected hidden>中項目</option>
						<option value=""></option>
					</select>
					<fieldset disabled hidden>
						{foreach from=$categoriesM key="parent" item="categories"}
						<select name="categories[]" class="form-select" data-parent="{$parent|escape:"html"}">
							<option value="" hidden>中項目</option>
							<option value=""></option>
							{foreach from=$categories key="code" item="category"}
								<option value="{$code|escape:"html"}"{if $code eq $data.categories[1]} selected{/if}>{$category.name|escape:"html"}</option>
							{/foreach}
						</select>
						{/foreach}
					</fieldset>
				</div>
				<div class="invalid-feedback"></div>
			</div>
			<div class="col-12 col-md-4 mt-1 mt-md-0">
				<div data-categories="s">
					<select name="categories[]" class="form-select" data-parent="">
						<option value="" selected hidden>小項目</option>
						<option value=""></option>
					</select>
					<fieldset disabled hidden>
						{foreach from=$categoriesS key="parent" item="categories"}
						<select name="categories[]" class="form-select" data-parent="{$parent|escape:"html"}">
							<option value="" hidden>小項目</option>
							<option value=""></option>
							{foreach from=$categories key="code" item="category"}
								<option value="{$code|escape:"html"}"{if $code eq $data.categories[2]} selected{/if}>{$category.name|escape:"html"}</option>
							{/foreach}
						</select>
						{/foreach}
					</fieldset>
				</div>
				<div class="invalid-feedback"></div>
			</div>
		</div>
	</div>
	
	<label for="e{counter skip=0}" class="col-12 mt-5 form-label">ターゲット（必須）</label>
	<div class="col-12">
		<div data-name="targets">
			{foreach from=$targets key="code" item="target"}
			<div class="form-check form-check-inline">
				<input type="checkbox" name="targets[]" id="e{counter skip=0}" value="{$code|escape:"html"}" class="form-check-input"{if $code|in_array:$data.targets} checked{/if} /><label for="e{counter skip=1}" class="form-check-label">{$target.name|escape:"html"}</label>
			</div>
			{/foreach}
		</div>
		<div class="invalid-feedback"></div>
	</div>
	
	<label for="e{counter skip=0}" class="col-12 mt-5 form-label">媒体（必須）</label>
	<div class="col-12">
		<div data-name="medias">
			{foreach from=$medias key="code" item="media"}
			<div class="form-check form-check-inline">
				<input type="checkbox" name="medias[]" id="e{counter skip=0}" value="{$code|escape:"html"}" class="form-check-input"{if $code|in_array:$data.medias} checked{/if} /><label for="e{counter skip=1}" class="form-check-label">{$media.name|escape:"html"}</label>
			</div>
			{/foreach}
		</div>
		<div class="invalid-feedback"></div>
	</div>
	
	<label class="col-12 mt-5 form-label">関係者スタッフ名（任意）</label>
	<div class="row">
		<div class="col-12 col-md-6 col-lg-5">
			<label for="e{counter skip=0}" class="col-12">営業担当者名</label>
			<div>
				<input name="sales_staff" type="text" id="e{counter skip=1}" class="form-control" placeholder="入力してください" value="{$data.sales_staff|escape:"html"}" />
				<div class="invalid-feedback"></div>
			</div>
			
			<label for="e{counter skip=0}" class="col-12 mt-3">コピーライター</label>
			<div>
				<input name="copywriter" type="text" id="e{counter skip=1}" class="form-control" placeholder="入力してください" value="{$data.copywriter|escape:"html"}" />
				<div class="invalid-feedback"></div>
			</div>
		</div>
		
		<div class="col-12 col-md-6 col-lg-5 mt-3 mt-md-0">
			<label for="e{counter skip=0}" class="col-12">プランナー</label>
			<div>
				<input name="planner" type="text" id="e{counter skip=1}" class="form-control" placeholder="入力してください" value="{$data.planner|escape:"html"}" />
				<div class="invalid-feedback"></div>
			</div>
			
			<label for="e{counter skip=0}" class="col-12 mt-3">デザイナー</label>
			<div>
				<input name="designer" type="text" id="e{counter skip=1}" class="form-control" placeholder="入力してください" value="{$data.designer|escape:"html"}" />
				<div class="invalid-feedback"></div>
			</div>
		</div>
	</div>
	
	<label for="e{counter skip=0}" class="col-12 mt-5 form-label">提案内容／ポイント（必須）</label>
	<div class="col-12 col-lg-10">
		<textarea name="content" type="text" id="e{counter skip=1}" class="form-control" placeholder="入力してください">{$data.content|escape:"html"}</textarea>
		<div class="invalid-feedback"></div>
	</div>
	
	
	<label for="e{counter skip=0}" class="col-12 mt-5 form-label">タグ検索キーワード （必須）（成分名、オンパレ、タレント名など絞り込みやすい検索ワード）</label>
	<div>
		<div class="row" data-name="keyword">
			{for $foo=0 to 5}
			<div class="col-12 col-md-6 col-lg-5 mb-1"><input type="text" name="keyword[]" id="e{counter skip=1}" class="form-control" placeholder="入力してください"{if $foo|array_key_exists:$data.keywords} value="{$data.keywords[$foo]|escape:"html"}"{/if} /></div>
			{/for}
		</div>
		<div class="invalid-feedback"></div>
	</div>
	
	<label for="e{counter skip=0}" class="col-12 mt-5 form-label">メディアライブラリ（PDF）（必須）</label>
	<div class="col-12">
		<div class="d-flex flex-wrap gap-3" id="pdf">
			<div class="card mb-3 d-flex text-center card-select">ファイルを選択</div>
		</div>
		<div class="invalid-feedback"></div>
	</div>
	
	<label for="e{counter skip=0}" class="col-12 mt-5 form-label">メディアライブラリ（PowerPoint、Keynote、Excelなど）（必須）</label>
	<div class="col-12">
		<div class="d-flex flex-wrap gap-3" id="vnd">
			<div class="card mb-3 d-flex text-center card-select">ファイルを選択</div>
		</div>
		<div class="invalid-feedback"></div>
	</div>
	
	<div class="col-12">
		<div data-name="files">{foreach from=$data.files item="file"}
		<a href="{url controller="Archive" action="proposal" id=$file.filename}" data-type="{$file.type|escape:"html"}" data-name="{$file.filename|escape:"html"}"></a>
		{/foreach}</div>
		<div class="invalid-feedback"></div>
	</div>
	
	<label for="e{counter skip=0}" class="col-12 mt-5 form-label">説明録画（任意）</label>
	<div class="col-12">
		<button type="button" class="btn btn-outline-danger btn-rec"><i class="bi bi-camera-video-fill"></i>Rec</button>
		<button type="button" data-bs-toggle="modal" data-bs-target="#recModal" hidden></button>
	</div>
	
	<div class="col-12 mt-5 text-center">
		<button type="submit" class="btn btn-success rounded-pill w-25 d-inline-flex"><div class="flex-grow-1"></div>キャンセル<div class="flex-grow-1"></div></button>
		<button type="submit" class="btn btn-success rounded-pill w-25 d-inline-flex"><div class="flex-grow-1"></div>編集保存<div class="flex-grow-1"></div></button>
		<button type="button" class="btn btn-danger rounded-pill w-25 d-inline-flex" data-bs-toggle="modal" data-bs-target="#deleteModal"><div class="flex-grow-1"></div>案件削除<div class="flex-grow-1"></div></button>
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
			<div class="modal-body" id="video">{if $data.videoExists}
				<video autoplay="autoplay" controls="controls" playsinline="playsinline"><source src="/file/video/{$data.id|escape:"html"}.webm" type="video/webm" /></video>
			{/if}</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-primary btn-rec2"{if $data.videoExists} style="display:none;"{/if}>録画</button>
				<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
			</div>
		</div>
	</div>
</div>
<div class="modal fade" id="deleteModal" tabindex="-1">
	<div class="modal-dialog modal-dialog-centered">
		<div class="modal-content">
			<div class="modal-header flex-row-reverse">
				<i class="bi bi-x" data-bs-dismiss="modal"></i>
			</div>
			<div class="modal-body">
				<div class="text-center text-danger">本当に削除しますか？</div>
			</div>
			<div class="modal-footer justify-content-evenly">
				<button type="button" class="btn btn-success rounded-pill w-25 d-inline-flex" data-action="{url action="delete" id=$data.id}"><div class="flex-grow-1"></div>はい<div class="flex-grow-1"></div></button>
				<button type="button" class="btn btn-outline-success rounded-pill w-25 d-inline-flex" data-bs-dismiss="modal"><div class="flex-grow-1"></div>いいえ<div class="flex-grow-1"></div></button>
			</div>
		</div>
	</div>
</div>
{/block}