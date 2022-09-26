<?php
namespace Config;
define('CWD', getcwd());
define('PROPOSAL_THUMBNAIL_DIR', CWD . DIRECTORY_SEPARATOR . "file" . DIRECTORY_SEPARATOR . "thumbnail" . DIRECTORY_SEPARATOR);
define('PROPOSAL_FILE_DIR', CWD . DIRECTORY_SEPARATOR . "file" . DIRECTORY_SEPARATOR . "data" . DIRECTORY_SEPARATOR);
define('DATA_DIR', dirname(__FILE__, 2) . DIRECTORY_SEPARATOR);
spl_autoload_register(function($class){
	$fileName = DATA_DIR . strtolower(str_replace('\\', '/', $class)) . '.php';
	if(file_exists($fileName)){
		include $fileName;
	}
});

// リクエスト
$url = parse_url(urldecode($_SERVER['REQUEST_URI']));
$requestStr = ltrim($url["path"], "/");
$controller = "Default";
$action = "index";
$id = null;

// コントローラー
if($url != ""){
	$items = explode("/", $requestStr);
	$cnt = count($items);
	if($cnt > 0 && $items[0] != ""){
		$controller = $items[0];
	}
	if($cnt > 1 && $items[1] != ""){
		$action = $items[1];
	}
	if($cnt > 2){
		$id = implode("/", array_slice($items, 2));
	}
}

// コンテキスト
$requestContext = new \App\RequestContext();
$requestContext->controller = $controller;
$requestContext->action = $action;
$requestContext->id = $id;

// アクション
$controllerClassName = "\\Controller\\{$controller}Controller";
$controllerInstance = new $controllerClassName($requestContext);
session_start();
$returnValue = $controllerInstance->$action();

// ビュー
if($returnValue instanceof \App\IView){
	$returnValue($requestContext, false);
}else if($returnValue instanceof \App\IHttpResponse){
	$returnValue($requestContext);
}
