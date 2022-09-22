<?php
namespace Model;

class Session{
	public static function isLogin(){
		return isset($_SESSION["User.id"]);
	}
	public static function getDB(){
		$role = $_SESSION["User.role"] ?? "default";
		return new \App\MySQL($role);
	}
	
	/**
		User.*にログインユーザー情報を格納
	*/
	public static function login($user){
		session_regenerate_id();
		foreach($user as $k => $v){
			$_SESSION["User.{$k}"] = $v;
		}
	}
	public static function logout(){
		unset($_SESSION);
		session_destroy();
	}
}