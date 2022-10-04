<?php
namespace Model;
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
		$check["username"]->required("ユーザー名またはメールアドレスを入力してください。");
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
				->andWhere("username=?", $_POST["username"])
				->andWhere("password=?", $_POST["password"]);
			if($user = $query()){
				$result->addMessage("ログインに成功しました。", "INFO", "");
				Session::login($user);
			}else{
				$result->addMessage("ログインに失敗しました。", "ERROR", "");
			}
		}catch(Exception $ex){
			$result->addMessage($ex->getMessage(), "ERROR", "");
		}
		return $result;
	}
}