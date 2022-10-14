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

class ClientMasterController extends ControllerBase{
	public function index(){
		$db = Session::getDB();
		$v = new View();
		
		$query = $db->select("ALL")
			->addTable("clients")
			->andWhere("delete_flag=0");
		$v["clients"] = $query();
		
		return $v;
	}
	public function regist(){
		$db = Session::getDB();
		
		// 検証
		$check = new Validator();
		$check["name"]->required("クライアント名称を入力してください。")
			->length("クライアント名称は60文字以下で入力してください。", null, 255);
		$check["zip"]->required("郵便番号を入力してください。")
			->zip("郵便番号を正しく入力してください。");
		$check["address1"]->required("都道府県を入力してください。")
			->length("都道府県は60文字以下で入力してください。", null, 255);
		$check["address2"]->required("市区町村・番地を入力してください。")
			->length("市区町村・番地は60文字以下で入力してください。", null, 255);
		$check["address3"]->length("建物名・号室は60文字以下で入力してください。", null, 255);
		$check["phone"]->required("電話番号を入力してください。")
			->tel("電話番号を正しく入力してください。");
		$check["close"]->required("請求書締日を入力してください。")
			->length("請求書締日は60文字以下で入力してください。", null, 255);
		$check["fax"]->tel("FAX番号を正しく入力してください。");
		$check["payment"]->required("入金日を入力してください。")
			->length("入金日は60文字以下で入力してください。", null, 255);
		$check["cycle"]->required("入金サイクルを入力してください。")
			->length("入金サイクルは60文字以下で入力してください。", null, 255);
		$result = $check($_POST);
		
		$id = null;
		if(!$result->hasError()){
			$db->beginTransaction();
			try{
				$insertQuery = $db->insertSet("clients", [
					"name" => $_POST["name"],
					"zip" => $_POST["zip"],
					"address1" => $_POST["address1"],
					"address2" => $_POST["address2"],
					"address3" => $_POST["address3"],
					"phone" => $_POST["phone"],
					"close" => $_POST["close"],
					"fax" => $_POST["fax"],
					"payment" => $_POST["payment"],
					"cycle" => $_POST["cycle"],
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
			->addTable("clients")
			->andWhere("id=?", $this->requestContext->id)
			->andWhere("delete_flag=0");
		$v["data"] = $query();
		return $v;
	}
	public function update(){
		$db = Session::getDB();
		$id = $this->requestContext->id;
		
		$query = $db->select("ROW")
			->addTable("clients")
			->andWhere("id=?", $id)
			->andWhere("delete_flag=0");
		$data = $query();
		
		// 検証
		$check = new Validator();
		$check["name"]->required("クライアント名称を入力してください。")
			->length("クライアント名称は60文字以下で入力してください。", null, 255);
		$check["zip"]->required("郵便番号を入力してください。")
			->zip("郵便番号を正しく入力してください。");
		$check["address1"]->required("都道府県を入力してください。")
			->length("都道府県は60文字以下で入力してください。", null, 255);
		$check["address2"]->required("市区町村・番地を入力してください。")
			->length("市区町村・番地は60文字以下で入力してください。", null, 255);
		$check["address3"]->length("建物名・号室は60文字以下で入力してください。", null, 255);
		$check["phone"]->required("電話番号を入力してください。")
			->tel("電話番号を正しく入力してください。");
		$check["close"]->required("請求書締日を入力してください。")
			->length("請求書締日は60文字以下で入力してください。", null, 255);
		$check["fax"]->tel("FAX番号を正しく入力してください。");
		$check["payment"]->required("入金日を入力してください。")
			->length("入金日は60文字以下で入力してください。", null, 255);
		$check["cycle"]->required("入金サイクルを入力してください。")
			->length("入金サイクルは60文字以下で入力してください。", null, 255);
		$result = $check($_POST);
		
		if(!$result->hasError()){
			$db->beginTransaction();
			try{
				$updateQuery = $db->updateSet("clients", [
					"name" => $_POST["name"],
					"zip" => $_POST["zip"],
					"address1" => $_POST["address1"],
					"address2" => $_POST["address2"],
					"address3" => $_POST["address3"],
					"phone" => $_POST["phone"],
					"close" => $_POST["close"],
					"fax" => $_POST["fax"],
					"payment" => $_POST["payment"],
					"cycle" => $_POST["cycle"],
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
			@Logger::record($db, "編集", ["clients" => $data["id"]]);
		}
		return new JsonView($result);
	}
	public function delete(){
		$db = Session::getDB();
		$id = $_POST["id"];
		
		$query = $db->select("ROW")
			->addTable("clients")
			->andWhere("id=?", $id)
			->andWhere("delete_flag=0");
		$data = $query();
		
		$result = new Result();
		$db->beginTransaction();
		try{
			$updateQuery = $db->updateSet("clients", [],[
				"delete_flag" => "1",
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
			@Logger::record($db, "削除", ["clients" => $data["id"]]);
		}
		
		return new JsonView($result);
	}
}