<?php
namespace Controller;
use App\ControllerBase;
use App\View;
use Model\Session;

class MemberController extends ControllerBase{
	public function index(){
		$v = new View();
		$v["categories"] = \App\Master\Data::Category();
		$v["clients"] = \App\Master\Data::Client();
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
				$searchCategoryStr .= "%";
			}
			if(($_POST["categories"][1] ?? "") != ""){
				$searchCategoryStr .= ",?";
				$searchCategoryParam[] = $_POST["categories"][1];
			}else{
				$searchCategoryStr .= ",%";
			}
			if(($_POST["categories"][2] ?? "") != ""){
				$searchCategoryStr .= ",?";
				$searchCategoryParam[] = $_POST["categories"][2];
			}else{
				$searchCategoryStr .= ",%";
			}
			$query->andWhere("proposals.categories like {$searchCategoryStr}", ...$searchCategoryParam);
		}
		if(isset($_POST["targets"]) && is_array($_POST["targets"])){
			// ターゲット
			$pattern = "^(?=(.*,)" . implode('(,|$))(?=(.*,)?', $_POST["targets"]) . '(,|$))';
			$query->andWhere("proposals.targets regexp ?", $pattern);
		}
		if(isset($_POST["medias"]) && is_array($_POST["medias"])){
			// 媒体
			$pattern = "^(?=(.*,)" . implode('(,|$))(?=(.*,)?', $_POST["medias"]) . '(,|$))';
			$query->andWhere("proposals.medias regexp ?", $pattern);
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
}