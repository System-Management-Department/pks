<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
{block name="styles"}
<link rel="stylesheet" type="text/css" href="/assets/bootstrap/css/bootstrap.min.css" />
{/block}
{block name="scripts"}
<script type="text/javascript" src="/assets/bootstrap/js/bootstrap.min.js"></script>
<script type="text/javascript">{literal}
document.addEventListener("DOMContentLoaded", function(){
	let main = document.querySelector("main");
	let rect = main.getBoundingClientRect();
	main.style.minHeight = `calc(100vh - ${rect.y + window.pageYOffset}px)`;
});
{/literal}</script>
{/block}
</head>
<body>
    <nav class="navbar navbar-light bg-dark">
        <div class="d-flex col-3 col-lg-2 flex-wrap flex-md-nowrap justify-content-end">
            <svg class="d-inline" width="24" height="24" viewBox="0 0 32 32">
                <path fill="white" d="M11,16h20c0.6,0,1,0.4,1,1l0,0c0,0.6-0.4,1-1,1H11c-0.6,0-1-0.4-1-1l0,0C10,16.4,10.4,16,11,16z M1,4h30c0.6,0,1,0.4,1,1l0,0c0,0.6-0.4,1-1,1H1C0.4,6,0,5.6,0,5l0,0C0,4.4,0.4,4,1,4z M1,28h30c0.6,0,1,0.4,1,1l0,0c0,0.6-0.4,1-1,1H1c-0.6,0-1-0.4-1-1l0,0C0,28.4,0.4,28,1,28z M7.7,22.7c0.4-0.4,0.4-1,0-1.4L3.4,17l4.3-4.3c0.4-0.4,0.4-1,0-1.4s-1-0.4-1.4,0L0.6,17l5.7,5.7C6.5,22.9,6.7,23,7,23S7.5,22.9,7.7,22.7z"></path>
            </svg>
        </div>
        <div class="d-flex col-9 col-lg-10 align-items-center justify-content-end">
            <span class="text-white">Logout</span>
        </div>
    </nav>
    <div class="container-fluid">
        <div class="row">
            <nav id="sidebar" class="col-md-3 col-lg-2 d-md-block bg-dark text-white sidebar collapse">
                <div class="position-sticky">
                    提案書管理システム
                    <ul class="nav flex-column">
                        <li class="nav-item">
                          <a class="nav-link text-white active" href="{url controller="Member" action="index"}">
                            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-home"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path><polyline points="9 22 9 12 15 12 15 22"></polyline></svg>
                            <span class="ml-2">ホーム</span>
                          </a>
                        </li>
                        <li class="nav-item">
                          <a class="nav-link text-white" href="{url controller="Member" action="index"}">
                            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-file"><path d="M13 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V9z"></path><polyline points="13 2 13 9 20 9"></polyline></svg>
                            <span class="ml-2">過去事例検索画面</span>
                          </a>
                        </li>
                        <li class="nav-item">
                          <a class="nav-link text-white" href="{url controller="Member" action="create"}">新規</a>
                        </li>
                      </ul>
                </div>
            </nav>
            <main class="col-md-9 ml-sm-auto col-lg-10 px-0">
            	{block name="title"}{/block}
				<div class="px-md-4 py-4">
					{block name="body"}{/block}
				</div>
            </main>
        </div>
    </div>
</body>
</html>