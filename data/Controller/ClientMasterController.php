<?php
namespace Controller;
use App\ControllerBase;
use App\View;
use App\JsonView;
use App\RedirectResponse;
use App\Validator;
use Model\Session;

class ClientMasterController extends ControllerBase{
	public function index(){
		$db = Session::getDB();
		$v = new View();
		
		$query = $db->select("ALL")
			->addTable("clients")
			->andWhere("delete_flag=0");
		$v["clients"] = $query();
		
		return $v;
	}
	public function regist(){
		$db = Session::getDB();
		
		// 検証
		$check = new Validator();
		$check["name"]->required("クライアント名称を入力してください。")
			->length("クライアント名称は60文字以下で入力してください。", null, 255);
		$check["zip"]->required("郵便番号を入力してください。")
			->zip("郵便番号を正しく入力してください。");
		$check["address1"]->required("都道府県を入力してください。")
			->length("都道府県は60文字以下で入力してください。", null, 255);
		$check["address2"]->required("市区町村・番地を入力してください。")
			->length("市区町村・番地は60文字以下で入力してください。", null, 255);
		$check["address3"]->length("建物名・号室は60文字以下で入力してください。", null, 255);
		$check["phone"]->required("電話番号を入力してください。")
			->tel("電話番号を正しく入力してください。");
		$check["close"]->required("請求書締日を入力してください。")
			->length("請求書締日は60文字以下で入力してください。", null, 255);
		$check["fax"]->tel("FAX番号を正しく入力してください。");
		$check["payment"]->required("入金日を入力してください。")
			->length("入金日は60文字以下で入力してください。", null, 255);
		$check["cycle"]->required("入金サイクルを入力してください。")
			->length("入金サイクルは60文字以下で入力してください。", null, 255);
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
		$check["name"]->required("クライアント名称を入力してください。")
			->length("クライアント名称は60文字以下で入力してください。", null, 255);
		$check["zip"]->required("郵便番号を入力してください。")
			->zip("郵便番号を正しく入力してください。");
		$check["address1"]->required("都道府県を入力してください。")
			->length("都道府県は60文字以下で入力してください。", null, 255);
		$check["address2"]->required("市区町村・番地を入力してください。")
			->length("市区町村・番地は60文字以下で入力してください。", null, 255);
		$check["address3"]->length("建物名・号室は60文字以下で入力してください。", null, 255);
		$check["phone"]->required("電話番号を入力してください。")
			->tel("電話番号を正しく入力してください。");
		$check["close"]->required("請求書締日を入力してください。")
			->length("請求書締日は60文字以下で入力してください。", null, 255);
		$check["fax"]->tel("FAX番号を正しく入力してください。");
		$check["payment"]->required("入金日を入力してください。")
			->length("入金日は60文字以下で入力してください。", null, 255);
		$check["cycle"]->required("入金サイクルを入力してください。")
			->length("入金サイクルは60文字以下で入力してください。", null, 255);
		$result = $check($_POST);
		
		return new JsonView($result);
	}
	public function delete(){
		$db = Session::getDB();
		return new JsonView($result);
	}
}