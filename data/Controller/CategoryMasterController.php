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

class CategoryMasterController extends ControllerBase{
	#[\Attribute\AcceptRole("admin")]
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
	
	#[\Attribute\AcceptRole("admin")]
	public function create(){
		$db = Session::getDB();
		$v = new View();
		$v->assign($this->getCategories($db));
		return $v ;
	}
	
	#[\Attribute\AcceptRole("admin")]
	public function regist(){
		$db = Session::getDB();
		
		// 検証
		$check = new Validator();
		$check["l"]->required("大分類を入力してください。")
			->length("大分類は60文字以下で入力してください。", null, 255);
		$check["m"]->required("中分類を入力してください。")
			->length("中分類は60文字以下で入力してください。", null, 255);
		$check["name"]->required("小分類を入力してください。")
			->length("小分類は60文字以下で入力してください。", null, 255);
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
	
	#[\Attribute\AcceptRole("admin")]
	public function edit(){
		$db = Session::getDB();
		$v = new View();
		
		$query = $db->select("ROW")
			->addTable("categories")
			->andWhere("id=?", $this->requestContext->id)
			->andWhere("delete_flag=0");
		$v["data"] = $query();
		
		$query = $db->select("ASSOC")
			->addTable("categories")
			->addField("id,name")
			->andWhere("delete_flag=0");
		$v["categoryName"] = $query();
		
		return $v;
	}
	
	#[\Attribute\AcceptRole("admin")]
	public function update(){
		$db = Session::getDB();
		$id = $this->requestContext->id;
		
		$query = $db->select("ROW")
			->addTable("categories")
			->andWhere("id=?", $id)
			->andWhere("delete_flag=0");
		$data = $query();
		$name = match(true){
			is_null($data["large_id"]) => "大分類",
			is_null($data["middle_id"]) => "中分類",
			default => "小分類",
		};
		
		// 検証
		$check = new Validator();
		$check["name"]->required("{$name}を入力してください。")
			->length("{$name}は60文字以下で入力してください。", null, 255);
		$result = $check($_POST);
		
		if(!$result->hasError()){
			$query = $db->select("ONE")
				->addTable("categories")
				->addField("count(1)")
				->andWhere("delete_flag=0")
				->andWhere("name=?", $_POST["name"])
				->andWhere("id<>?", $id);
			if(is_null($data["large_id"])){
				$query->andWhere("large_id is null");
			}else{
				$query->andWhere("large_id=?", $data["large_id"]);
			}
			if(is_null($data["middle_id"])){
				$query->andWhere("middle_id is null");
			}else{
				$query->andWhere("middle_id=?", $data["middle_id"]);
			}
			if($query() > 0){
				$result->addMessage("既に登録済みです。", "ERROR", "name");
			}
		}
		
		if(!$result->hasError()){
			$db->beginTransaction();
			try{
				$updateQuery = $db->updateSet("categories", [
					"name" => $_POST["name"],
				],[]);
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
			@Logger::record($db, "編集", ["category" => [$data["large_id"], $data["middle_id"], $data["id"]]]);
		}
		
		return new JsonView($result);
	}
	
	#[\Attribute\AcceptRole("admin")]
	public function delete(){
		$db = Session::getDB();
		$id = $_POST["id"];
		
		$query = $db->select("ROW")
			->addTable("categories")
			->andWhere("id=?", $id)
			->andWhere("delete_flag=0");
		$data = $query();
		
		$result = new Result();
		$db->beginTransaction();
		try{
			$updateQuery = $db->updateSet("categories", [],[
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
			@Logger::record($db, "削除", ["category" => $data["id"]]);
		}
		
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