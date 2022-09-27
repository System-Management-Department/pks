<?php
namespace Controller;
use App\ControllerBase;
use App\View;
use Model\Session;

class MemberController extends ControllerBase{
	public function index(){
		$db = Session::getDB();
		$v = new View();
		
		// カテゴリ
		$this->setCategoriesSelectData($db, $v);
		
		// 顧客
		$query = $db->select("ASSOC")
			->addTable("clients")
			->addField("id,name");
		$v["clients"] = $query();
		
		// ターゲット
		$query = $db->select("ASSOC")
			->addTable("targets")
			->addField("id,name");
		$v["targets"] = $query();
		
		// 媒体
		$query = $db->select("ASSOC")
			->addTable("medias")
			->addField("id,name");
		$v["medias"] = $query();
		return $v;
	}
	public function listItem(){
		$db = Session::getDB();
		$query = $db->select("ALL")
			->setLimit($limit = 20)
			->addTable("proposals")
			->addField("proposals.*")
			
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
		$v["proposals"] = $proposals;
		$v["lastdata"] = $lastdata;
		return $v->setLayout(null);
	}
	public function regist(){
		var_dump($this->requestContext->getFiles("file"));
		var_dump($this->requestContext->getFiles("thumbnail"));
	}
	private function setCategoriesSelectData($db, $v){
		$query = $db->select("ASSOC")
			->addTable("categories")
			->addField("id,name,large_id,middle_id");
		$categories = $query();
		$categoriesL = [];
		$categoriesM = [];
		$categoriesS = [];
		foreach($categories as $id => $data){
			if(is_null($data["large_id"])){
				$categoriesL[$id] = $data;
			}else if(is_null($data["middle_id"])){
				if(!array_key_exists($data["large_id"], $categoriesM)){
					$categoriesM[$data["large_id"]] = [];
				}
				$categoriesM[$data["large_id"]][$id] = $data;
			}else{
				if(!array_key_exists($data["middle_id"], $categoriesS)){
					$categoriesS[$data["middle_id"]] = [];
				}
				$categoriesS[$data["middle_id"]][$id] = $data;
			}
		}
		$v["categoriesL"] = $categoriesL;
		$v["categoriesM"] = $categoriesM;
		$v["categoriesS"] = $categoriesS;
		
	}
}