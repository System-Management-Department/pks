<?php
namespace Controller;
use App\ControllerBase;
use App\View;
use App\JsonView;
use App\RedirectResponse;
use Model\Session;
use Model\Proposal;

class MemberController extends ControllerBase{
	#[\Attribute\AcceptRole("admin", "entry", "browse")]
	public function index(){
		$db = Session::getDB();
		$v = new View();
		
		// マスターデータ
		$v->assign($this->getMasterData($db, true));
		
		return $v;
	}
	
	#[\Attribute\AcceptRole("admin", "entry", "browse")]
	public function list(){
		if($_SERVER["REQUEST_METHOD"] == "GET"){
			return new RedirectResponse("Member", "index");
		}
		
		return new View();
	}
	
	#[\Attribute\AcceptRole("admin", "entry", "browse")]
	public function listItem(){
		$db = Session::getDB();
		$query = Proposal::getSearchQuery($db, $_POST);
		$proposals = $query();
		$lastdata = (count($proposals) == Proposal::$limit) ? end($proposals)["id"] : "";
		
		$v = new View();
		$v->assign($this->getMasterData($db, false));
		$v["proposals"] = $proposals;
		$v["lastdata"] = $lastdata;
		if(count($proposals) == 0){
			$v->setAction("_emptyList");
		}
		return $v->setLayout(null);
	}
	
	#[\Attribute\AcceptRole("admin", "entry", "browse")]
	public function browse(){
		$db = Session::getDB();
		$query = Proposal::getRowQuery($db);
		$query->andWhere("id=?", intval($_POST["proposal"]));
		$data = $query();
		if(empty($data)){
			return new RedirectResponse("Member", "index");
		}
		
		$v = new View();
		
		// マスターデータ
		$v->assign($this->getMasterData($db, false));
		$data["categories"] = explode(",", $data["categories"]);
		$data["targets"] = explode(",", $data["targets"]);
		$data["medias"] = explode(",", $data["medias"]);
		$data["keywords"] = explode("\t", $data["keywords"]);
		$data["files"] = is_null($data["filename"]) ? [] : json_decode($data["filename"], true);
		$data["videoExists"] = file_exists(PROPOSAL_VIDEO_DIR . "{$_POST["proposal"]}.webm");
		$v["data"] = $data;
		
		return $v;
	}
	
	#[\Attribute\AcceptRole("admin", "entry")]
	public function create(){
		$db = Session::getDB();
		$v = new View();
		
		// マスターデータ
		$v->assign($this->getMasterData($db, true));
		
		return $v;
	}
	
	#[\Attribute\AcceptRole("admin", "entry")]
	public function regist(){
		$db = Session::getDB();
		$masterData = $this->getMasterData($db, false);
		
		// 入力値検証
		$result = Proposal::checkInsert($db, $_POST, $masterData, $this->requestContext);
		if(!$result->hasError()){
			// 登録
			Proposal::execInsert($db, $_POST, $this->requestContext, $result);
		}
		return new JsonView($result);
	}
	
	#[\Attribute\AcceptRole("admin", "entry")]
	public function edit(){
		$db = Session::getDB();
		$query = Proposal::getRowQuery($db);
		$query->andWhere("id=?", intval($_POST["proposal"]))
			->andWhere("author=@user");
		$data = $query();
		if(empty($data)){
			return new RedirectResponse("Member", "index");
		}
		
		$v = new View();
		
		// マスターデータ
		$videoFile = PROPOSAL_VIDEO_DIR . "{$_POST["proposal"]}.webm";
		$v->assign($this->getMasterData($db, true));
		$data["categories"] = explode(",", $data["categories"]);
		$data["targets"] = explode(",", $data["targets"]);
		$data["medias"] = explode(",", $data["medias"]);
		$data["keywords"] = explode("\t", $data["keywords"]);
		$data["files"] = is_null($data["filename"]) ? [] : json_decode($data["filename"], true);
		if($data["videoExists"] = file_exists($videoFile)){
			$data["videoDateTime"] = date( "Y-m-d H:i:s", filemtime($videoFile));
		}
		$v["data"] = $data;
		
		return $v;
	}
	
	#[\Attribute\AcceptRole("admin", "entry")]
	public function update(){
		$db = Session::getDB();
		$masterData = $this->getMasterData($db, false);
		
		// 入力値検証
		$result = Proposal::checkUpdate($db, $_POST, $masterData, $this->requestContext);
		if(!$result->hasError()){
			// 更新
			Proposal::execUpdate($db, $_POST, $this->requestContext, $result);
		}
		return new JsonView($result);
	}
	
	#[\Attribute\AcceptRole("admin", "entry")]
	public function delete(){
		$db = Session::getDB();
		$result = Proposal::execDelete($db, $this->requestContext);
		return new JsonView($result);
	}
	
	private function getMasterData($db, $tree = true){
		$data = [];
		
		// ユーザ
		$query = $db->select("ASSOC")
			->addTable("users")
			->addField("id,username")
			->andWhere("disabled=0");
		$data["users"] = $query();
		
		// 顧客
		$query = $db->select("ASSOC")
			->addTable("clients")
			->addField("id,name")
			->andWhere("delete_flag=0");
		$data["clients"] = $query();
		
		// ターゲット
		$query = $db->select("ASSOC")
			->addTable("targets")
			->addField("id,name")
			->andWhere("delete_flag=0");
		$data["targets"] = $query();
		
		// 媒体
		$query = $db->select("ASSOC")
			->addTable("medias")
			->addField("id,name")
			->andWhere("delete_flag=0");
		$data["medias"] = $query();
		
		// カテゴリ
		$query = $db->select("ASSOC")
			->addTable("categories")
			->addField("id,name,large_id,middle_id")
			->andWhere("delete_flag=0");
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
}