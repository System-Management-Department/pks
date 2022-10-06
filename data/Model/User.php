<?php
namespace Model;
use stdClass;
use App\Validator;
use App\MySQL as Database;

class User{
	public static function login(){
		$result = new Result();
		if(Session::isLogin()){
			$result->addMessage("すでにログインしています。", "ERROR", "");
			return $result;
		}
		
		$check = new Validator();
		$check["email"]->required("ユーザー名またはメールアドレスを入力してください。");
		$check["password"]->required("パスワードを入力してください。");
		$check($result, $_POST);
		if($result->hasError()){
			return $result;
		}
		
		try{
			$db = new Database();
			$query = $db
				->select("ROW")
				->setTable("users")
				->addField("*")
				->andWhere("disabled=0")
				->andWhere("email=?", $_POST["email"])
				->andWhere("password=?", $_POST["password"]);
			if($user = $query()){
				$result->addMessage("ログインに成功しました。", "INFO", "");
				Session::login($db, $user);
				Logger::record($db, "ログイン", new stdClass());
			}else{
				$result->addMessage("ログインに失敗しました。", "ERROR", "");
			}
		}catch(Exception $ex){
			$result->addMessage($ex->getMessage(), "ERROR", "");
		}
		return $result;
	}
	
	public static function setDBVariables($db, $assoc){
		$query = $db
			->select("ROW")
			->addField("@user:=?", $assoc["id"] ?? 0)
			->addField("@username:=?", $assoc["username"] ?? "");
		$query();
	}
}