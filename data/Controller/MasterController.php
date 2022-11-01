<?php
namespace Controller;
use Exception;
use App\ControllerBase;
use App\StreamView;
use App\JsonView;
use Model\Session;
use Model\Logger;
use Model\Result;

class MasterController extends ControllerBase{
	#[\Attribute\AcceptRole("admin")]
	public function download(){
		$db = Session::getDB();
		$table = $this->requestContext->id;
		$query = $db->select("ALL")
			->addTable($table);
		$data = $query();
		
		$fp = fopen("php://temp", "r+b");
		fwrite($fp, "\xEF\xBB\xBF");
		foreach($data as $row){
			fputcsv($fp, $row);
		}
		rewind($fp);
		$v = new StreamView($fp, "text/csv");
		fclose($fp);
		@Logger::record($db, "エクスポート", ["master" => $table]);
		return $v;
	}
	
	#[\Attribute\AcceptRole("admin")]
	public function upload(){
		$db = Session::getDB();
		$fp = null;
		$files = $this->requestContext->getFiles("data");
		foreach($files as $file){
			$fp = fopen($file['tmp_name'], "r");
			break;
		}
		if(is_null($fp)){
			return;
		}
		$reset = true;
		$data = [];
		while(($row = fgetcsv($fp)) !== false){
			if($reset){
				$reset = false;
				$row[0] = preg_replace("/^\\xEF\\xBB\\xBF/", "", $row[0]);
			}
			$data[] = $row;
		}
		fclose($fp);
		$table = $this->requestContext->id;
		$result = new Result();
		$db->beginTransaction();
		try{
			$deleteQuery = $db->delete($table);
			$deleteQuery();
			$insertQuery = $db->insertSelect($table, "*");
			$insertQuery->addTable("JSON_TABLE(?, '\$[*]' " . $db->getJsonTableColumns($table) . ") t", json_encode($data));
			$insertQuery();
			$db->commit();
			@Logger::record($db, "インポート", ["master" => $table]);
		}catch(Exception $ex){
			$result->addMessage("アップロードに失敗しました。", "ERROR", "");
			$result->setData($ex);
			$db->rollback();
		}
		if(!$result->hasError()){
			$result->addMessage("登録が完了しました。", "INFO", "");
		}
		return new JsonView($result);
	}
}