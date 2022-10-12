<?php
namespace Controller;
use App\ControllerBase;
use App\View;
use App\JsonView;
use App\RedirectResponse;
use App\Validator;
use Model\Session;

class UserMasterController extends ControllerBase{
	public function index(){
		$db = Session::getDB();
		$v = new View();
		
		$query = $db->select("ALL")
			->addTable("users")
			->andWhere("disabled=0");
		$v["users"] = $query();
		
		return $v;
	}
	public function regist(){
		$db = Session::getDB();
		
		// 検証
		$check = new Validator();
		$check["name"]->required("ユーザー名を入力してください。")
			->length("ユーザー名は60文字以下で入力してください。", null, 255);
		$check["email"]->required("メールアドレスを入力してください。")
			->mail("メールアドレスを正しく入力してください。");
		$check["password"]->required("パスワードを入力してください。")
			->length("パスワードは6～12文字で入力してください。", 6, 12)
			->password("このパスワードは設定できません。");
		$check["department"]->required("所属部署名を選択してください。")
			->length("所属部署名は60文字以下で入力してください。", null, 255);
		$check["role"]->required("権限グループを選択してください。")
			->range("権限グループを正しく入力してください。", "in", ["admin", "entry", "browse"]);
		$result = $check($_POST);
		
		return new JsonView($result);
	}
	public function edit(){
		$db = Session::getDB();
		return new View();
	}
	public function update(){
		$db = Session::getDB();
		
		// 検証
		$check = new Validator();
		$check["name"]->required("ユーザー名を入力してください。")
			->length("ユーザー名は60文字以下で入力してください。", null, 255);
		$check["email"]->required("メールアドレスを入力してください。")
			->mail("メールアドレスを正しく入力してください。");
		$check["password"]->required("パスワードを入力してください。")
			->length("パスワードは6～12文字で入力してください。", 6, 12)
			->password("このパスワードは設定できません。");
		$check["department"]->required("所属部署名を選択してください。")
			->length("所属部署名は60文字以下で入力してください。", null, 255);
		$check["role"]->required("権限グループを選択してください。")
			->range("権限グループを正しく入力してください。", "in", ["admin", "entry", "browse"]);
		$result = $check($_POST);
		
		return new JsonView($result);
	}
	public function delete(){
		$db = Session::getDB();
		return new JsonView($result);
	}
}