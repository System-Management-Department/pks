<?php
namespace Controller;
use App\ControllerBase;
use App\View;

class DefaultController extends ControllerBase{
	public function index(){
		$db = new \App\MySQL();
		$q = $db
			->select()
			->setTable("users")
			->addField("username")
			->addField("password");
		var_dump($q());
		$v = new View();
		return $v->setLayout("Shared" . DIRECTORY_SEPARATOR . "_simple_html.tpl");
	}
	
	
}