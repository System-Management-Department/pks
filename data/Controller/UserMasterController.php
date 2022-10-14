<?php
namespace Controller;
use Exception;
use App\ControllerBase;
use App\View;
use App\JsonView;
use App\RedirectResponse;
use App\Validator;
use Model\Session;
use Model\Logger;
use Model\Result;

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
		$check["username"]->required("ユーザー名を入力してください。")
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
		
		$id = null;
		$query = $db->select("ONE")
			->addTable("users")
			->addField("id")
			->andWhere("disabled=0")
			->andWhere("email=?", $_POST["email"]);
		$id = $query();
		if($id !== false){
			$result->addMessage("既に登録済みです。", "ERROR", "email");
		}
		
		if(!$result->hasError()){
			$db->beginTransaction();
			try{
				$insertQuery = $db->insertSet("users", [
					"username" => $_POST["username"],
					"email" => $_POST["email"],
					"password" => $_POST["password"],
					"department" => $_POST["department"],
					"role" => $_POST["role"],
				],[
					"created" => "now()",
					"modified" => "now()",
				]);
				$insertQuery($id);
				$db->commit();
			}catch(Exception $ex){
				$result->addMessage("編集保存に失敗しました。", "ERROR", "");
				$result->setData($ex);
				$db->rollback();
			}
		}
		if(!$result->hasError()){
			$result->addMessage("編集保存が完了しました。", "INFO", "");
			@Logger::record($db, "登録", ["users" => $id]);
		}
		
		return new JsonView($result);
	}
	public function edit(){
		$db = Session::getDB();
		$v = new View();
		
		$query = $db->select("ROW")
			->addTable("users")
			->andWhere("id=?", $this->requestContext->id)
			->andWhere("disabled=0");
		$v["data"] = $query();
		return $v;
	}
	public function update(){
		$db = Session::getDB();
		$id = $this->requestContext->id;
		
		$query = $db->select("ROW")
			->addTable("users")
			->andWhere("id=?", $id)
			->andWhere("disabled=0");
		$data = $query();
		
		// 検証
		$check = new Validator();
		$check["username"]->required("ユーザー名を入力してください。")
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
		
		$query = $db->select("ONE")
			->addTable("users")
			->addField("count(1)")
			->andWhere("disabled=0")
			->andWhere("email=?", $_POST["email"])
			->andWhere("id<>?", $id);
		if($query() > 0){
			$result->addMessage("既に登録済みです。", "ERROR", "email");
		}
		
		if(!$result->hasError()){
			$db->beginTransaction();
			try{
				$updateQuery = $db->updateSet("users", [
					"username" => $_POST["username"],
					"email" => $_POST["email"],
					"password" => $_POST["password"],
					"department" => $_POST["department"],
					"role" => $_POST["role"],
				],[
					"modified" => "now()",
				]);
				$updateQuery->andWhere("id=?", $id);
				$updateQuery();
				$db->commit();
			}catch(Exception $ex){
				$result->addMessage("編集保存に失敗しました。", "ERROR", "");
				$result->setData($ex);
				$db->rollback();
			}
		}
		if(!$result->hasError()){
			$result->addMessage("編集保存が完了しました。", "INFO", "");
			@Logger::record($db, "編集", ["users" => $data["id"]]);
		}
		return new JsonView($result);
	}
	public function delete(){
		$db = Session::getDB();
		$id = $_POST["id"];
		
		$query = $db->select("ROW")
			->addTable("users")
			->andWhere("id=?", $id)
			->andWhere("disabled=0");
		$data = $query();
		
		$result = new Result();
		$db->beginTransaction();
		try{
			$updateQuery = $db->updateSet("users", [],[
				"disabled" => "1",
			]);
			$updateQuery->andWhere("id=?", $id);
			$updateQuery();
			$db->commit();
		}catch(Exception $ex){
			$result->addMessage("削除に失敗しました。", "ERROR", "");
			$result->setData($ex);
			$db->rollback();
		}
		if(!$result->hasError()){
			$result->addMessage("削除が完了しました。", "INFO", "");
			@Logger::record($db, "削除", ["users" => $data["id"]]);
		}
		
		return new JsonView($result);
	}
}