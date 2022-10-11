<?php
namespace Controller;
use App\ControllerBase;
use App\View;
use App\JsonView;
use App\RedirectResponse;
use Model\Session;

class CategoryMasterController extends ControllerBase{
	public function index(){
		$db = Session::getDB();
		$v = new View();
		
		$query = $db->select("ALL")
			->addTable("categories")
			->andWhere("middle_id is not null");
		$v["categories"] = $query();
		
		$query = $db->select("ASSOC")
			->addTable("categories")
			->addField("id,name");
		$v["categoryName"] = $query();
		
		return $v;
	}
	public function regist(){
		$db = Session::getDB();
		return new JsonView($result);
	}
	public function edit(){
		$db = Session::getDB();
		return new View();
	}
	public function update(){
		$db = Session::getDB();
		return new JsonView($result);
	}
	public function delete(){
		$db = Session::getDB();
		return new JsonView($result);
	}
}