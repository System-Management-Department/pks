<?php
namespace Controller;
use App\ControllerBase;
use App\View;
use App\JsonView;
use App\RedirectResponse;
use Model\Result;

class DefaultController extends ControllerBase{
	public function index(){
		if(isset($_SESSION["id"])){
			// ログインされていればリダイレクト
			return new RedirectResponse("Member", "index");
		}else{
			// ログインされていなければフォームを表示
			$v = new View();
			return $v->setLayout("Shared" . DIRECTORY_SEPARATOR . "_simple_html.tpl");
		}
	}
	
	public function login(){
		$result = new Result();
		try{
			$db = new \App\MySQL();
			if($_POST["username"] == ""){
				$result->addMessage("ユーザー名またはメールアドレスを入力してください。", "ERROR");
			}
			if($_POST["password"] == ""){
				$result->addMessage("パスワードを入力してください。", "ERROR");
			}
			if(!$result->hasError()){
				$query = $db
					->select("ROW")
					->setTable("users")
					->addField("*")
					->andWhere("username=?", $_POST["username"])
					->andWhere("password=?", $_POST["password"]);
				if($a = $query()){
					$result->addMessage("ログインに成功しました。", "INFO");
					$_SESSION["id"] = $a["id"];
				}else{
					$result->addMessage("ログインに失敗しました。", "ERROR");
				}
			}
		}catch(Exception $ex){
			$result->addMessage($ex->getMessage(), "ERROR");
		}
		return new JsonView($result);
	}
	
	public function logout(){
		unset($_SESSION);
		session_destroy();
		return new RedirectResponse("", "index");
	}
}