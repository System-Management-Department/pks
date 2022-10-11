<?php
namespace Controller;
use App\ControllerBase;
use App\View;
use App\JsonView;
use App\RedirectResponse;
use Model\Session;

class MediaMasterController extends ControllerBase{
	public function index(){
		$db = Session::getDB();
		$v = new View();
		
		$query = $db->select("ALL")
			->addTable("medias");
		$v["medias"] = $query();
		
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