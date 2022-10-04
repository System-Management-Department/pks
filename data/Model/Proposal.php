<?php
namespace Model;
use ZipArchive;
use App\Validator;

class Proposal{
	public static $limit = 20;
	public static function getSearchQuery($db, $q){
		$query = $db->select("ALL")
			->setLimit(self::$limit)
			->addTable("proposals")
			->addField("proposals.*")
			->leftJoin("(SELECT proposal as id, json_arrayagg(json_object('filename',filename,'type',type)) as filename FROM files GROUP BY proposal) file using(id)")
			->addField("file.filename")
			
			// 読込：IDを降順で取得
			->setOrderBy("proposals.id desc");
		
		if(!empty($q["lastdata"])){
			// 途中から読込
			$query->andWhere("proposals.id<?", $q["lastdata"]);
		}
		
		// 検索条件
		if(preg_match('/^([0-9]{4,})[\\/\\-]([0-9]{1,2})[\\/\\-]([0-9]{1,2})$/', ($q["modified_date"] ?? ""), $matches)){
			// 提案日
			$query->andWhere("proposals.modified_date=concat(?, '-', ?, '-', ?)", $matches[1], $matches[2], $matches[3]);
		}
		if(($q["client"] ?? "") != ""){
			// クライアント名
			$query->andWhere("proposals.client=?", $q["client"]);
		}
		if(($q["product_name"] ?? "") != ""){
			// 商材名
			$query->andWhere("proposals.product_name like concat('%', ?, '%')", preg_replace("/(?=[_%])/", "\\", $q["product_name"]));
		}
		if(isset($q["categories"]) && is_array($q["categories"])){
			// クライアントカテゴリー
			$searchCategoryStr = "";
			$searchCategoryParam = [];
			if(($q["categories"][0] ?? "") != ""){
				$searchCategoryStr .= "?";
				$searchCategoryParam[] = $q["categories"][0];
			}else{
				$searchCategoryStr .= "'%'";
			}
			if(($q["categories"][1] ?? "") != ""){
				$searchCategoryStr .= ",',',?";
				$searchCategoryParam[] = $q["categories"][1];
			}else{
				$searchCategoryStr .= ",',%'";
			}
			if(($q["categories"][2] ?? "") != ""){
				$searchCategoryStr .= ",',',?";
				$searchCategoryParam[] = $q["categories"][2];
			}else{
				$searchCategoryStr .= ",',%'";
			}
			$query->andWhere("proposals.categories like concat({$searchCategoryStr})", ...$searchCategoryParam);
		}
		if(isset($q["targets"]) && is_array($q["targets"])){
			// ターゲット
			$pattern = "^(?=(.*,)?" . implode('(,|$))(?=(.*,)?', $q["targets"]) . '(,|$))';
			$query->andWhere("proposals.targets regexp ?", $pattern);
		}
		if(isset($q["medias"]) && is_array($q["medias"])){
			// 媒体
			$pattern = "^(?=(.*,)?" . implode('(,|$))(?=(.*,)?', $q["medias"]) . '(,|$))';
			$query->andWhere("proposals.medias regexp ?", $pattern);
		}
		if(($q["sales_staff"] ?? "") != ""){
			// 営業担当者名
			$query->andWhere("proposals.sales_staff like concat('%', ?, '%')", preg_replace("/(?=[_%])/", "\\", $q["sales_staff"]));
		}
		if(($q["planner"] ?? "") != ""){
			// プランナー
			$query->andWhere("proposals.planner like concat('%', ?, '%')", preg_replace("/(?=[_%])/", "\\", $q["planner"]));
		}
		if(($q["copywriter"] ?? "") != ""){
			// コピーライター
			$query->andWhere("proposals.copywriter like concat('%', ?, '%')", preg_replace("/(?=[_%])/", "\\", $q["copywriter"]));
		}
		if(($q["designer"] ?? "") != ""){
			// デザイナー
			$query->andWhere("proposals.designer like concat('%', ?, '%')", preg_replace("/(?=[_%])/", "\\", $q["designer"]));
		}
		if(($q["content"] ?? "") != ""){
			// 提案内容／ポイント
			$query->andWhere("proposals.content like concat('%', ?, '%')", preg_replace("/(?=[_%])/", "\\", $q["content"]));
		}
		if(!empty($q["keyword"])){
			// キーワード
			$keywords = [];
			foreach($q["keyword"] as $keyword){
				if(is_null($keyword) || ($keyword == "")){
					continue;
				}
				$keywords[] = "(?=.*" . preg_quote($keyword) . ")";
			}
			if(!empty($keywords)){
				$keywordPattern = "^" . implode("", $keywords);
				$query->andWhere("proposals.keywords regexp ?", $keywordPattern);
			}
		}
		return $query;
	}
	
	public static function getRowQuery($db){
		$query = $db->select("ROW")
			->addTable("proposals")
			->addField("proposals.*")
			->leftJoin("(SELECT proposal as id, json_arrayagg(json_object('filename',filename,'type',type)) as filename FROM files GROUP BY proposal) file using(id)")
			->addField("file.filename");
		return $query;
	}
	
	
	
	public static function checkInsert($db, $q, $masterData, $context){
		$check = new Validator();
		$query = self::validate($check, $masterData, $db, array_key_exists("files", $q) ? $q["files"] : []);
		$result = $check($q);
		if($query() != "0"){
			$result->addMessage("登録済みのファイル名と重複します。", "ERROR", "files");
		}
		$thumbnail = $context->getFiles("thumbnail");
		if(empty($thumbnail)){
			$result->addMessage("サムネイルが選択されていません。", "ERROR", "thumbnail");
		}
		return $result;
	}
	
	public static function checkUpdate($db, $q, $masterData, $context){
		$id = $context->id;
		$check = new Validator();
		$query = self::validate($check, $masterData, $db, array_key_exists("files", $q) ? $q["files"] : []);
		$result = $check($q);
		$query->andWhere("proposal<>?", $id);
		if($query() != "0"){
			$result->addMessage("登録済みのファイル名と重複します。", "ERROR", "files");
		}
		$thumbnail = $context->getFiles("thumbnail");
		if(empty($thumbnail)){
			$result->addMessage("サムネイルが選択されていません。", "ERROR", "thumbnail");
		}
		return $result;
	}
	
	/**
		登録・更新共通の検証
	*/
	public static function validate($check, $masterData, $db, $files){
		$check["modified_date"]->required("提案年月日を入力してください。");
		$check["client"]->required("クライアント名を入力してください。")
			->range("クライアント名を正しく入力してください。", "in", array_keys($masterData["clients"]));
		$check["product_name"]->required("商材名を入力してください。")
			->length("商材名は60文字以下で入力してください。", null, 255);
		$check["sales_staff"]->length("営業担当者名は60文字以下で入力してください。", null, 255);
		$check["copywriter"]->length("コピーライターは60文字以下で入力してください。", null, 255);
		$check["planner"]->length("プランナーは60文字以下で入力してください。", null, 255);
		$check["designer"]->length("デザイナーは60文字以下で入力してください。", null, 255);
		$check["content"]->required("提案内容／ポイントを入力してください。");
		
		$check->setArray("categories", [
			"alias" => ["categories0", "categories1", "categories2"],
			"format" => [["大項目"], ["中項目"], ["小項目"]]
		]);
		$check["categories"]->required("クライアント　カテゴリー（%s）を入力してください。")
			->range("クライアント　カテゴリー（%s）を正しく入力してください。", "in", array_keys($masterData["categories"]));
		
		$check->setArray("keyword", [
			"blankFilter" => true,
			"empty" => "検索キーワードを入力してください。"
		]);
		
		$check->setArray("targets", ["empty" => "ターゲットを入力してください。"]);
		$check["targets"]->range("ターゲットを正しく入力してください。", "in", array_keys($masterData["targets"]));
		
		$check->setArray("medias", ["empty" => "媒体を入力してください。"]);
		$check["medias"]->range("媒体を正しく入力してください。", "in", array_keys($masterData["medias"]));
		
		return $query = $db->select("ONE")
			->addTable("files")
			->addField("count(1)")
			->andWhere("filename in(SELECT filename FROM JSON_TABLE(?, '$[*]' COLUMNS(filename TEXT COLLATE 'utf8mb4_unicode_ci' PATH '$.name')) t)", json_encode($files));
	}
	
	
	
	public static function execInsert($db, $q, $context, $result){
		try{
			// データベース挿入
			$keywords = [];
			foreach($q["keyword"] as $keyword){
				if(is_null($keyword) || ($keyword == "")){
					continue;
				}
				$keywords[] = preg_replace("/[[:cntrl:]]/", " ", $keyword);
			}
			
			$insertQuery = $db->insertSet("proposals", [
				"client" => $q["client"],
				"product_name" => $q["product_name"],
				"categories" => implode(",", $q["categories"]),
				"keywords" => implode("\t", $keywords),
				"targets" => implode(",", $q["medias"]),
				"medias" => implode(",", $q["medias"]),
				"modified_date" => $q["modified_date"],
				"sales_staff" => $q["sales_staff"],
				"planner" => $q["planner"],
				"copywriter" => $q["copywriter"],
				"designer" => $q["designer"],
				"content" => $q["content"],
			],[
				"created" => "now()",
				"modified" => "now()",
			]);
			$insertQuery($id);
			
			$insertQuery = $db->insertSelect("files", "proposal, uploaded, filename, type");
			$insertQuery->addTable("(SELECT ? as proposal, now() as uploaded) t1", $id)
				->addField("DISTINCT t1.proposal, t1.uploaded")
				->addTable("JSON_TABLE(?, '$[*]' COLUMNS(filename TEXT PATH '$.name', type TEXT PATH '$.type')) t2", json_encode($q["files"]))
				->addField("t2.filename, t2.type");
			$insertQuery();
			
			// ファイルアップロード
			$zip = new ZipArchive();
			$zip->open(PROPOSAL_FILE_DIR . "{$id}.zip", ZipArchive::CREATE);
			$files = $context->getFiles("archive");
			foreach($files as $file){
				$zip->addFile($file['tmp_name'], $file['name']);
			}
			$zip->close();
			
			$thumbnail = $context->getFiles("thumbnail");
			file_put_contents(PROPOSAL_THUMBNAIL_DIR . "{$id}.png", file_get_contents($thumbnail[0]['tmp_name']));
			
			$video = $context->getFiles("video");
			if(!empty($video)){
				file_put_contents(PROPOSAL_VIDEO_DIR . "{$id}.webm", file_get_contents($video[0]['tmp_name']));
			}
		}catch(Exception $ex){
			$result->addMessage("登録に失敗しました。", "ERROR", "");
			$result->setData($ex);
		}
		if(!$result->hasError()){
			$result->addMessage("登録が完了しました。", "INFO", "");
		}
	}
	public static function execUpdate($db, $q, $context, $result){
		$id = $context->id;
		try{
			// データベース更新
			$keywords = [];
			foreach($q["keyword"] as $keyword){
				if(is_null($keyword) || ($keyword == "")){
					continue;
				}
				$keywords[] = preg_replace("/[[:cntrl:]]/", " ", $keyword);
			}
			
			$updateQuery = $db->updateSet("proposals", [
				"client" => $q["client"],
				"product_name" => $q["product_name"],
				"categories" => implode(",", $q["categories"]),
				"keywords" => implode("\t", $keywords),
				"targets" => implode(",", $q["medias"]),
				"medias" => implode(",", $q["medias"]),
				"modified_date" => $q["modified_date"],
				"sales_staff" => $q["sales_staff"],
				"planner" => $q["planner"],
				"copywriter" => $q["copywriter"],
				"designer" => $q["designer"],
				"content" => $q["content"],
			],[
				"modified" => "now()",
			]);
			$updateQuery->andWhere("id=?", $id);
			$updateQuery();
			
			$deleteQuery = $db->delete("files");
			$deleteQuery->andWhere("proposal=?", $id);
			$deleteQuery();
			
			$insertQuery = $db->insertSelect("files", "proposal, uploaded, filename, type");
			$insertQuery->addTable("(SELECT ? as proposal, now() as uploaded) t1", $id)
				->addField("DISTINCT t1.proposal, t1.uploaded")
				->addTable("JSON_TABLE(?, '$[*]' COLUMNS(filename TEXT PATH '$.name', type TEXT PATH '$.type')) t2", json_encode($q["files"]))
				->addField("t2.filename, t2.type");
			$insertQuery();
			
			// ファイルアップロード
			$zip = new ZipArchive();
			$zip->open(PROPOSAL_FILE_DIR . "{$id}.zip", ZipArchive::CREATE);
			$files = $context->getFiles("archive");
			foreach($files as $file){
				$zip->addFile($file['tmp_name'], $file['name']);
			}
			$zip->close();
			
			$thumbnail = $context->getFiles("thumbnail");
			file_put_contents(PROPOSAL_THUMBNAIL_DIR . "{$id}.png", file_get_contents($thumbnail[0]['tmp_name']));
			
			$video = $context->getFiles("video");
			if(empty($video)){
				@unlink(PROPOSAL_VIDEO_DIR . "{$id}.webm");
			}else{
				file_put_contents(PROPOSAL_VIDEO_DIR . "{$id}.webm", file_get_contents($video[0]['tmp_name']));
			}
		}catch(Exception $ex){
			$result->addMessage("更新に失敗しました。", "ERROR", "");
			$result->setData($ex);
		}
		if(!$result->hasError()){
			$result->addMessage("更新が完了しました。", "INFO", "");
		}
	}
	
}