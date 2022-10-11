<?php
function smarty_function_role($params, $template){
	return match($params["code"]){
		"admin" => "管理者",
		"entry" => "一般ユーザー",
		"browse" => "閲覧権限",
		default => ""
	};
}