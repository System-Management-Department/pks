<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
{block name="styles"}
<link rel="stylesheet" type="text/css" href="/assets/bootstrap/css/bootstrap.min.css" />
<link rel="stylesheet" type="text/css" href="/assets/fontawesome/css/fontawesome.min.css" />
<link rel="stylesheet" type="text/css" href="/assets/fontawesome/css/solid.min.css" />
<style id="additionalStyle"></style>
{/block}
{block name="scripts"}
<script type="text/javascript" src="/assets/bootstrap/js/bootstrap.min.js"></script>
<script type="text/javascript">{literal}
document.addEventListener("DOMContentLoaded", function(){
	const additionalStyle = document.getElementById("additionalStyle");
	const styleSheet = additionalStyle.sheet;
	let n = styleSheet.cssRules.length;
	
	styleSheet.insertRule(`nav.navbar.position-sticky{
		z-index: 1000;
	}`, n++);
	let main = document.getElementById("mainContents");
	let rect = main.getBoundingClientRect();
	styleSheet.insertRule(`#mainRow{
		height: calc(100vh - ${rect.y + window.pageYOffset}px);
		overflow: auto;
		--main-top: ${rect.y + window.pageYOffset}px;
	}`, n++);
	styleSheet.insertRule(`#sidebar>.position-sticky{
		z-index: 1000;
	}`, n++);
});
{/literal}</script>
{/block}
</head>
<body>
    <nav class="navbar navbar-light position-sticky top-0 bg-dark text-white py-1">
        <div class="d-flex col-3 col-lg-2 flex-wrap flex-md-nowrap justify-content-end px-3">
            <i class="fa-solid fa-bars"></i>
        </div>
        <div class="d-flex col-9 col-lg-10 align-items-center justify-content-end px-3">
            <a href="{url controller="Default" action="logout"}" class="text-white">Logout<i class="fa-solid fa-right-to-bracket"></i></a>
        </div>
    </nav>
    <div class="container-fluid">
        <div id="mainRow" class="row">
            <nav id="sidebar" class="col-md-3 col-lg-2 d-md-block bg-dark text-white sidebar collapse">
                <div class="position-sticky top-0">
                    提案書管理システム
                    <ul class="nav flex-column">
                        <li class="nav-item">
                          <a class="nav-link text-white active" href="{url controller="Member" action="index"}">
                            <span class="ml-2"><i class="fas fa-house"></i>ホーム</span>
                          </a>
                        </li>
                        <li class="nav-item">
                          <a class="nav-link text-white" href="{url controller="Member" action="index"}">
                            <span class="ml-2"><i class="fas fa-magnifying-glass"></i>過去事例検索画面</span>
                          </a>
                        </li>
                        <li class="nav-item">
                          <a class="nav-link text-white" href="{url controller="Member" action="create"}">新規</a>
                        </li>
                      </ul>
                </div>
            </nav>
            <main id="mainContents" class="col-md-9 ml-sm-auto col-lg-10 px-0">
            	{block name="title"}{/block}
				<div class="px-md-4 py-4">
					{block name="body"}{/block}
				</div>
            </main>
        </div>
    </div>
</body>
</html>