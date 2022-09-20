{block name="styles" append}
<style type="text/css">{literal}
body{
	min-height: 100vh;
	background: var(--bs-light, white);
}
.card{
	width: 420px;
}
{/literal}</style>
{/block}

{block name="body"}
<main class="text-center pt-5">
	<h1>提案書管理システム</h1>
	
	<form class="text-start card mt-5 mx-auto">
		<div class="card-body row">
			<label class="col-12">ユーザー名またはメールアドレス</label>
			<div class="col-12"><input type="text" class="form-control" /></div>
			
			<label class="col-12 mt-3">パスワード</label>
			<div class="col-12"><input type="text" class="form-control" /></div>
			
			<label class="text-center col-12 mt-3"><input type="checkbox">ログイン状態を保持する</label>
			<div class="text-center col-12 mt-3 mb-3"><a href="/Member/" class="btn btn-success">ログイン</a></div>
			<div class="text-center col-12">パスワードを忘れた方はこちら</div>
		</div>
	</form>
</main>
{/block}