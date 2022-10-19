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
		let expires = new Date();
		
		if(document.querySelector('form input[type="checkbox"]:checked') == null){
			expires.setFullYear(expires.getFullYear() - 1);
			document.cookie = `session=0;expires=${expires.toUTCString()}`;
		}else{
			expires.setFullYear(expires.getFullYear() + 1);
			document.cookie = `session=1;expires=${expires.toUTCString()}`;
		}
		fetch(form.getAttribute("action"), {
			method: form.getAttribute("method"),
			body: formData,
		}).then(res => res.json()).then(json => {
			if(json.success){
				location.reload();
			}else{
				alert(json.messages.reduce((a, msg) => {
					a.push(msg[0]);
					return a;
				}, []).join("\n"));
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
			<div class="col-12"><input name="email" type="text" class="form-control" /></div>
			
			<label class="col-12 mt-3">パスワード</label>
			<div class="col-12"><input name="password" type="text" class="form-control" /></div>
			
			<label class="text-center col-12 mt-3"><input type="checkbox">ログイン状態を保持する</label>
			<div class="text-center col-12 mt-3 mb-3"><button type="submit" class="btn btn-success">ログイン</button></div>
			<div class="text-center col-12">パスワードを忘れた方はこちら</div>
		</div>
	</form>
</main>
{/block}