<?php
namespace Controller;
use App\ControllerBase;
use App\View;
use App\JsonView;
use App\RedirectResponse;
use Model\Session;
use Model\User;

class DefaultController extends ControllerBase{
	public function index(){
		if(Session::isLogin()){
			// ログインされていればリダイレクト
			return new RedirectResponse("Member", "index");
		}else{
			// ログインされていなければフォームを表示
			$v = new View();
			return $v->setLayout("Shared" . DIRECTORY_SEPARATOR . "_simple_html.tpl");
		}
	}
	
	public function login(){
		$result = User::login();
		return new JsonView($result);
	}
	
	public function logout(){
		Session::logout();
		return new RedirectResponse("", "index");
	}
}