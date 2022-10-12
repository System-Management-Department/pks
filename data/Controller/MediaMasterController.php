<?php
namespace Controller;
use App\ControllerBase;
use App\View;
use App\JsonView;
use App\RedirectResponse;
use App\Validator;
use Model\Session;

class MediaMasterController extends ControllerBase{
	public function index(){
		$db = Session::getDB();
		$v = new View();
		
		$query = $db->select("ALL")
			->addTable("medias")
			->andWhere("delete_flag=0");
		$v["medias"] = $query();
		
		return $v;
	}
	public function regist(){
		$db = Session::getDB();
		
		// 検証
		$check = new Validator();
		$check["name"]->required("媒体名称を入力してください。")
			->length("媒体名称は60文字以下で入力してください。", null, 255);
		$result = $check($_POST);
		
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
		$check["name"]->required("媒体名称を入力してください。")
			->length("媒体名称は60文字以下で入力してください。", null, 255);
		$result = $check($_POST);
		
		return new JsonView($result);
	}
	public function delete(){
		$db = Session::getDB();
		return new JsonView($result);
	}
}