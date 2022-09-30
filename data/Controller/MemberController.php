<?php
namespace Controller;
use App\ControllerBase;
use App\View;
use App\JsonView;
use Model\Session;

class MemberController extends ControllerBase{
	public function index(){
		$db = Session::getDB();
		$v = new View();
		
		// マスターデータ
		$v->assign($this->getMasterData($db, true));
		
		return $v;
	}
	public function listItem(){
		$db = Session::getDB();
		$query = $db->select("ALL")
			->setLimit($limit = 20)
			->addTable("proposals")
			->addField("proposals.*")
			->leftJoin("(SELECT proposal as id, json_arrayagg(json_object('filename',filename,'type',type)) as filename FROM files GROUP BY proposal) file using(id)")
			->addField("file.filename")
			
			// 読込：IDを降順で取得
			->setOrderBy("proposals.id desc");
		
		if(!empty($_POST["lastdata"])){
			// 途中から読込
			$query->andWhere("proposals.id<?", $_POST["lastdata"]);
		}
		
		// 検索条件
		if(preg_match('/^([0-9]{4,})[\\/\\-]([0-9]{1,2})[\\/\\-]([0-9]{1,2})$/', ($_POST["modified_date"] ?? ""), $matches)){
			// 提案日
			$query->andWhere("proposals.modified_date=concat(?, '-', ?, '-', ?)", $matches[1], $matches[2], $matches[3]);
		}
		if(($_POST["client"] ?? "") != ""){
			// クライアント名
			$query->andWhere("proposals.client=?", $_POST["client"]);
		}
		if(($_POST["product_name"] ?? "") != ""){
			// 商材名
			$query->andWhere("proposals.product_name like concat('%', ?, '%')", preg_replace("/(?=[_%])/", "\\", $_POST["product_name"]));
		}
		if(isset($_POST["categories"]) && is_array($_POST["categories"])){
			// クライアントカテゴリー
			$searchCategoryStr = "";
			$searchCategoryParam = [];
			if(($_POST["categories"][0] ?? "") != ""){
				$searchCategoryStr .= "?";
				$searchCategoryParam[] = $_POST["categories"][0];
			}else{
				$searchCategoryStr .= "'%'";
			}
			if(($_POST["categories"][1] ?? "") != ""){
				$searchCategoryStr .= ",',',?";
				$searchCategoryParam[] = $_POST["categories"][1];
			}else{
				$searchCategoryStr .= ",',%'";
			}
			if(($_POST["categories"][2] ?? "") != ""){
				$searchCategoryStr .= ",',',?";
				$searchCategoryParam[] = $_POST["categories"][2];
			}else{
				$searchCategoryStr .= ",',%'";
			}
			$query->andWhere("proposals.categories like concat({$searchCategoryStr})", ...$searchCategoryParam);
		}
		if(isset($_POST["targets"]) && is_array($_POST["targets"])){
			// ターゲット
			$pattern = "^(?=(.*,)?" . implode('(,|$))(?=(.*,)?', $_POST["targets"]) . '(,|$))';
			$query->andWhere("proposals.targets regexp ?", $pattern);
		}
		if(isset($_POST["medias"]) && is_array($_POST["medias"])){
			// 媒体
			$pattern = "^(?=(.*,)?" . implode('(,|$))(?=(.*,)?', $_POST["medias"]) . '(,|$))';
			$query->andWhere("proposals.medias regexp ?", $pattern);
		}
		if(($_POST["sales_staff"] ?? "") != ""){
			// 営業担当者名
			$query->andWhere("proposals.sales_staff like concat('%', ?, '%')", preg_replace("/(?=[_%])/", "\\", $_POST["sales_staff"]));
		}
		if(($_POST["planner"] ?? "") != ""){
			// プランナー
			$query->andWhere("proposals.planner like concat('%', ?, '%')", preg_replace("/(?=[_%])/", "\\", $_POST["planner"]));
		}
		if(($_POST["copywriter"] ?? "") != ""){
			// コピーライター
			$query->andWhere("proposals.copywriter like concat('%', ?, '%')", preg_replace("/(?=[_%])/", "\\", $_POST["copywriter"]));
		}
		if(($_POST["designer"] ?? "") != ""){
			// デザイナー
			$query->andWhere("proposals.designer like concat('%', ?, '%')", preg_replace("/(?=[_%])/", "\\", $_POST["designer"]));
		}
		if(($_POST["content"] ?? "") != ""){
			// 提案内容／ポイント
			$query->andWhere("proposals.content like concat('%', ?, '%')", preg_replace("/(?=[_%])/", "\\", $_POST["content"]));
		}
		
		$proposals = $query();
		$lastdata = (count($proposals) == $limit) ? end($proposals)["id"] : "";
		$v = new View();
		$v->assign($this->getMasterData($db, false));
		$v["proposals"] = $proposals;
		$v["lastdata"] = $lastdata;
		return $v->setLayout(null);
	}
	public function create(){
		$db = Session::getDB();
		$v = new View();
		
		// マスターデータ
		$v->assign($this->getMasterData($db, true));
		
		return $v;
	}
	public function regist(){
		$db = Session::getDB();
		$masterData = $this->getMasterData($db, false);
		
		// 入力値検証
		$check = new \App\Validator();
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
		$result = $check($_POST);
		
		$query = $db->select("ONE")
			->addTable("files")
			->addField("count(1)")
			->andWhere("filename in(SELECT filename FROM JSON_TABLE(?, '$[*]' COLUMNS(filename TEXT COLLATE 'utf8mb4_unicode_ci' PATH '$.name')) t)", json_encode(array_key_exists("files", $_POST) ? $_POST["files"] : []));
		if($query() != "0"){
			$result->addMessage("登録済みのファイル名と重複します。", "ERROR", "files");
		}
		
		$thumbnail = $this->requestContext->getFiles("thumbnail");
		if(empty($thumbnail)){
			$result->addMessage("サムネイルが選択されていません。", "ERROR", "thumbnail");
		}
		$video = $this->requestContext->getFiles("video");
		
		if($result->hasError()){
			return new JsonView($result);
		}
		
		// 登録
		try{
			$insertQuery = $db->insertSet("proposals", [
				"client" => $_POST["client"],
				"product_name" => $_POST["product_name"],
				"categories" => implode(",", $_POST["categories"]),
				"keywords" => implode("\t", array_filter($_POST["keyword"], [$this, "blankFilter"])),
				"targets" => implode(",", $_POST["medias"]),
				"medias" => implode(",", $_POST["medias"]),
				"modified_date" => $_POST["modified_date"],
				"sales_staff" => $_POST["sales_staff"],
				"planner" => $_POST["planner"],
				"copywriter" => $_POST["copywriter"],
				"designer" => $_POST["designer"],
				"content" => $_POST["content"],
			],[
				"created" => "now()",
				"modified" => "now()",
			]);
			$insertQuery($id);
			$insertQuery = $db->insertSelect("files", "proposal, uploaded, filename, type");
			$insertQuery->addTable("(SELECT ? as proposal, now() as uploaded) t1", $id)
				->addField("DISTINCT t1.proposal, t1.uploaded")
				->addTable("JSON_TABLE(?, '$[*]' COLUMNS(filename TEXT PATH '$.name', type TEXT PATH '$.type')) t2", json_encode($_POST["files"]))
				->addField("t2.filename, t2.type");
			$insertQuery();
			
			$zip = new \ZipArchive();
			$zip->open(PROPOSAL_FILE_DIR . "{$id}.zip", \ZipArchive::CREATE);
			$files = $this->requestContext->getFiles("archive");
			foreach($files as $file){
				$zip->addFile($file['tmp_name'], $file['name']);
			}
			$zip->close();
			
			file_put_contents(PROPOSAL_THUMBNAIL_DIR . "{$id}.png", file_get_contents($thumbnail[0]['tmp_name']));
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
		return new JsonView($result);
	}
	private function getMasterData($db, $tree = true){
		$data = [];
		
		// 顧客
		$query = $db->select("ASSOC")
			->addTable("clients")
			->addField("id,name");
		$data["clients"] = $query();
		
		// ターゲット
		$query = $db->select("ASSOC")
			->addTable("targets")
			->addField("id,name");
		$data["targets"] = $query();
		
		// 媒体
		$query = $db->select("ASSOC")
			->addTable("medias")
			->addField("id,name");
		$data["medias"] = $query();
		
		// カテゴリ
		$query = $db->select("ASSOC")
			->addTable("categories")
			->addField("id,name,large_id,middle_id");
		$categories = $query();
		if($tree){
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
		}else{
			$data["categories"] = $categories;
		}
		
		return $data;
	}
	private function blankFilter($data){
		return !(is_null($data) || ($data == ""));
	}
}