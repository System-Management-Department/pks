{block name="styles" append}
<style type="text/css">{literal}
body{
	min-height: 100vh;
	background: var(--bs-light, white);
}
.card{
	width: 320px;
}
{/literal}</style>
{/block}

{block name="scripts" append}
<script type="text/javascript" src="/assets/bootstrap/js/bootstrap.bundle.min.js"></script>
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
	new bootstrap.Tooltip(document.querySelector('[data-bs-toggle="tooltip"]'));
});
{/literal}</script>
{/block}

{block name="body"}
<main class="text-center pt-5">
	<div><img src="/assets/common/image/image1.svg" style="width:120px;" alt="PM" /></div>
	<div><img src="/assets/common/image/image2.svg" style="width:200px;" alt="Proposal Management System" /></div>
	<div class="text-start card mt-5 mx-auto py-3 px-3">
		<form action="{url action="login"}" method="POST" class="card-body row pb-0">
			<label class="col-12">メールアドレス</label>
			<div class="col-12"><input name="email" type="text" class="form-control" /></div>
			
			<label class="col-12 mt-3">パスワード</label>
			<div class="col-12"><input name="password" type="text" class="form-control" /></div>
			
			<div class="col-12 mt-3 text-center">
				<div class="form-check d-inline-block">
					<input class="form-check-input" type="checkbox" id="checkbox">
					<label class="form-check-label" for="checkbox">ログイン状態を保持する</label>
				</div>
			</div>
			<div class="text-center col-12 my-3"><button type="submit" class="btn btn-success">ログイン</button></div>
		</form>
		<form action="mailto:admin@direct-holdings.co.jp" method="GET" target="_blank" class="card-body row pt-0">
			<input type="hidden" name="subject" value="ここにタイトルを入力" />
			<input type="hidden" name="body" value="ここに本文を入力" />
			<div class="col-12 text-center">
				<button type="submit" class="btn text-decoration-underline" title="こちらをクリックすると、管理者にメールが送信されます。" data-bs-toggle="tooltip" data-bs-placement="top">パスワードを忘れた方はこちら</button>
			</div>
		</form>
	</div>
</main>
{/block}