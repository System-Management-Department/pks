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

{block name="scripts" append}
<script type="text/javascript">{literal}
document.addEventListener("DOMContentLoaded", function(){
	const form = document.querySelector('form');
	form.addEventListener("submit", e => {
		e.stopPropagation();
		e.preventDefault();
		let formData = new FormData(form);
		
		fetch(form.getAttribute("action"), {
			method: form.getAttribute("method"),
			body: formData,
		}).then(res => res.json()).then(json => {
			alert(json.messages.reduce((a, msg) => {
				a.push(msg[0]);
				return a;
			}, []).join("\n"));
			if(json.success){
				location.reload();
			}
		});
	});
});
{/literal}</script>
{/block}

{block name="body"}
<main class="text-center pt-5">
	<h1>提案書管理システム</h1>
	
	<form action="{url action="login"}" method="POST" class="text-start card mt-5 mx-auto">
		<div class="card-body row">
			<label class="col-12">ユーザー名またはメールアドレス</label>
			<div class="col-12"><input name="username" type="text" class="form-control" /></div>
			
			<label class="col-12 mt-3">パスワード</label>
			<div class="col-12"><input name="password" type="text" class="form-control" /></div>
			
			<label class="text-center col-12 mt-3"><input type="checkbox">ログイン状態を保持する</label>
			<div class="text-center col-12 mt-3 mb-3"><button type="submit" class="btn btn-success">ログイン</button></div>
			<div class="text-center col-12">パスワードを忘れた方はこちら</div>
			<div class="text-center col-12 mt-3 mb-3"><a href="{url controller="Member" action="index"}">ログイン</a></div>
		</div>
	</form>
</main>
{/block}