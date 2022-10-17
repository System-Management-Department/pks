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

class MediaMasterController extends ControllerBase{
	#[\Attribute\AcceptRole("admin")]
	public function index(){
		$db = Session::getDB();
		$v = new View();
		
		$query = $db->select("ALL")
			->addTable("medias")
			->andWhere("delete_flag=0");
		$v["medias"] = $query();
		
		return $v;
	}
	
	#[\Attribute\AcceptRole("admin")]
	public function regist(){
		$db = Session::getDB();
		
		// 検証
		$check = new Validator();
		$check["name"]->required("媒体名称を入力してください。")
			->length("媒体名称は60文字以下で入力してください。", null, 255);
		$result = $check($_POST);
		
		$id = null;
		if(!$result->hasError()){
			$db->beginTransaction();
			try{
				$query = $db->select("ONE")
					->addTable("medias")
					->addField("id")
					->andWhere("delete_flag=0")
					->andWhere("name=?", $_POST["name"]);
				$id = $query();
				if($id !== false){
					$result->addMessage("既に登録済みです。", "ERROR", "name");
				}else{
					$insertQuery = $db->insertSet("medias", [
						"name" => $_POST["name"],
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
			@Logger::record($db, "登録", ["medias" => $id]);
		}
		
		return new JsonView($result);
	}
	
	#[\Attribute\AcceptRole("admin")]
	public function edit(){
		$db = Session::getDB();
		$v = new View();
		
		$query = $db->select("ROW")
			->addTable("medias")
			->andWhere("id=?", $this->requestContext->id)
			->andWhere("delete_flag=0");
		$v["data"] = $query();
		return $v;
	}
	
	#[\Attribute\AcceptRole("admin")]
	public function update(){
		$db = Session::getDB();
		$id = $this->requestContext->id;
		
		$query = $db->select("ROW")
			->addTable("medias")
			->andWhere("id=?", $id)
			->andWhere("delete_flag=0");
		$data = $query();
		
		// 検証
		$check = new Validator();
		$check["name"]->required("媒体名称を入力してください。")
			->length("媒体名称は60文字以下で入力してください。", null, 255);
		$result = $check($_POST);
		
		if(!$result->hasError()){
			$query = $db->select("ONE")
				->addTable("medias")
				->addField("count(1)")
				->andWhere("delete_flag=0")
				->andWhere("name=?", $_POST["name"])
				->andWhere("id<>?", $id);
			if($query() > 0){
				$result->addMessage("既に登録済みです。", "ERROR", "name");
			}
		}
		
		if(!$result->hasError()){
			$db->beginTransaction();
			try{
				$updateQuery = $db->updateSet("medias", [
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
			@Logger::record($db, "編集", ["medias" => $data["id"]]);
		}
		return new JsonView($result);
	}
	
	#[\Attribute\AcceptRole("admin")]
	public function delete(){
		$db = Session::getDB();
		$id = $_POST["id"];
		
		$query = $db->select("ROW")
			->addTable("medias")
			->andWhere("id=?", $id)
			->andWhere("delete_flag=0");
		$data = $query();
		
		$result = new Result();
		$db->beginTransaction();
		try{
			$updateQuery = $db->updateSet("medias", [],[
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
			@Logger::record($db, "削除", ["medias" => $data["id"]]);
		}
		
		return new JsonView($result);
	}
}