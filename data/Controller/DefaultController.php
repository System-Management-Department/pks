<?php
namespace Controller;
use App\ControllerBase;
use App\View;
use App\JsonView;

class DefaultController extends ControllerBase{
	public function index(){
		$v = new View();
		return $v->setLayout("Shared" . DIRECTORY_SEPARATOR . "_simple_html.tpl");
	}
	
	public function login(){
		$response = [
			"result" => &$result
		];
		$db = new \App\MySQL();
		$q = $db
			->select()
			->setLimit(1)
			->setTable("users")
			->andWhere("username=?", $_POST["username"])
			->andWhere("password=?", $_POST["password"])
			->addField("*");
		$a = $q();
		$result = (count($a) == 1);
		return new JsonView($response);
	}
	
}