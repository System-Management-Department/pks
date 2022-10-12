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

class CategoryMasterController extends ControllerBase{
	public function index(){
		$db = Session::getDB();
		$v = new View();
		
		$query = $db->select("ALL")
			->addTable("categories")
			->andWhere("middle_id is not null")
			->andWhere("delete_flag=0");
		$v["categories"] = $query();
		
		$query = $db->select("ASSOC")
			->addTable("categories")
			->addField("id,name")
			->andWhere("delete_flag=0");
		$v["categoryName"] = $query();
		
		return $v;
	}
	public function create(){
		$db = Session::getDB();
		$v = new View();
		$v->assign($this->getCategories($db));
		return $v ;
	}
	public function regist(){
		$db = Session::getDB();
		
		// 検証
		$check = new Validator();
		$check["l"]->required("大項目を入力してください。")
			->length("大項目は60文字以下で入力してください。", null, 255);
		$check["m"]->required("中項目を入力してください。")
			->length("中項目は60文字以下で入力してください。", null, 255);
		$check["name"]->required("小項目を入力してください。")
			->length("小項目は60文字以下で入力してください。", null, 255);
		$result = $check($_POST);
		
		$largeId = null;
		$middleId = null;
		$id = null;
		if(!$result->hasError()){
			$db->beginTransaction();
			try{
				$query = $db->select("ONE")
					->addTable("categories")
					->addField("id")
					->andWhere("delete_flag=0")
					->andWhere("name=?", $_POST["l"]);
				$largeId = $query();
				if($largeId === false){
					$insertQuery = $db->insertSet("categories", [
						"name" => $_POST["l"],
					],[]);
					$insertQuery($largeId);
				}
				$query = $db->select("ONE")
					->addTable("categories")
					->addField("id")
					->andWhere("delete_flag=0")
					->andWhere("name=?", $_POST["m"])
					->andWhere("large_id=?", $largeId);
				$middleId = $query();
				if($middleId === false){
					$insertQuery = $db->insertSet("categories", [
						"name" => $_POST["m"],
						"large_id" => $largeId,
					],[]);
					$insertQuery($middleId);
				}
				$query = $db->select("ONE")
					->addTable("categories")
					->addField("id")
					->andWhere("delete_flag=0")
					->andWhere("name=?", $_POST["name"])
					->andWhere("large_id=?", $largeId)
					->andWhere("middle_id=?", $middleId);
				$id = $query();
				if($id !== false){
					$result->addMessage("既に登録済みです。", "ERROR", "");
				}else{
					$insertQuery = $db->insertSet("categories", [
						"name" => $_POST["name"],
						"large_id" => $largeId,
						"middle_id" => $middleId,
					],[]);
					$insertQuery($id);
				}
				$db->commit();
			}catch(Exception $ex){
				$result->addMessage("編集保存に失敗しました。", "ERROR", "");
				$result->setData($ex);
				$db->rollback();
			}
		}
		if(!$result->hasError()){
			$result->addMessage("編集保存が完了しました。", "INFO", "");
			@Logger::record($db, "登録", ["category" => [$largeId, $middleId, $id]]);
		}
		
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
		$check["name"]->required("小項目を入力してください。")
			->length("小項目は60文字以下で入力してください。", null, 255);
		$result = $check($_POST);
		
		return new JsonView($result);
	}
	public function delete(){
		$db = Session::getDB();
		return new JsonView($result);
	}
	private function getCategories($db){
		$data = [];
		$query = $db->select("ASSOC")
			->addTable("categories")
			->addField("id,name,large_id,middle_id")
			->andWhere("delete_flag=0");
		$categories = $query();
		$categoriesL = [];
		$categoriesM = [];
		$categoriesS = [];
		foreach($categories as $id => $rowData){
			if(is_null($rowData["large_id"])){
				$categoriesL[$id] = $rowData;
			}else if(is_null($rowData["middle_id"])){
				if(!array_key_exists($rowData["large_id"], $categoriesM)){
					$categoriesM[$rowData["large_id"]] = [];
				}
				$categoriesM[$rowData["large_id"]][$id] = $rowData;
			}else{
				if(!array_key_exists($rowData["middle_id"], $categoriesS)){
					$categoriesS[$rowData["middle_id"]] = [];
				}
				$categoriesS[$rowData["middle_id"]][$id] = $rowData;
			}
		}
		$data["categoriesL"] = $categoriesL;
		$data["categoriesM"] = $categoriesM;
		$data["categoriesS"] = $categoriesS;
		return $data;
	}
}