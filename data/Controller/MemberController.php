<?php
namespace Controller;
use App\ControllerBase;
use App\View;

class MemberController extends ControllerBase{
	public function index(){
		$v = new View();
		$v["categories"] = \App\Master\Data::Category();
		$v["clients"] = \App\Master\Data::Client();
		return $v;
	}
	public function listItem(){
		$fileList = [];
		$currentData = empty($_POST["lastdata"]) ? 0 : $_POST["lastdata"];
		for($i = 0; $i < 20; $i++){
			$filePath = "/file/thumbnail/{$currentData}.png";
			if(file_exists(CWD . str_replace("/", DIRECTORY_SEPARATOR, $filePath))){
				$fileList[] = ["thumbnail" => $filePath, "data" => ["/file/data/アミノミン&スタコラ 折込チラシご提案0914.pdf"]];
				$currentData++;
			}else{
				$currentData = "";
				break;
			}
		}
		$v = new View();
		$v["fileList"] = $fileList;
		$v["lastdata"] = $currentData;
		return $v->setLayout(null);
	}
	public function regist(){
		var_dump($this->requestContext->getFiles("file"));
		var_dump($this->requestContext->getFiles("thumbnail"));
	}
}