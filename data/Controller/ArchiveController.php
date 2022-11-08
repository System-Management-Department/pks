<?php
namespace Controller;
use ZipArchive;
use App\ControllerBase;
use App\StreamView;
use Model\Session;
use Model\Logger;

class ArchiveController extends ControllerBase{
	#[\Attribute\AcceptRole("admin", "entry", "browse")]
	public function proposal(){
		$db = Session::getDB();
		$query = $db->select("ROW")
			->addTable("files")
			->andWhere("id=?", $this->requestContext->id);
		$file = $query();
		$zip = new ZipArchive();
		$zip->open(PROPOSAL_FILE_DIR . "{$file["proposal"]}.zip", ZipArchive::RDONLY);
		$fp = $zip->getStream($file["filename"]);
		$v = new StreamView($fp, $file["type"]);
		fclose($fp);
		$zip->close();
		return $v;
	}
	
	#[\Attribute\AcceptRole("admin", "entry", "browse")]
	public function download(){
		if(!array_key_exists("filenames", $_POST)){
			return null;
		}
		$db = Session::getDB();
		$filenames = [];
		foreach($_POST["filenames"] as $name){
			$filenames[] = ["name" => $name];
		}
		
		$query = $db->select("ALL")
			->addTable("files")
			->andWhere("id in(SELECT id FROM JSON_TABLE(?, '$[*]' COLUMNS(id INT PATH '$.name')) t)", json_encode($filenames));
		$files = $query();
		
		// ファイルダウンロード
		$zipFile = tempnam(sys_get_temp_dir(), "ZIP");
		unlink($zipFile);
		$zip = new ZipArchive();
		$zip->open($zipFile, ZipArchive::CREATE);
		foreach($files as $file){
			$zip2 = new ZipArchive();
			$zip2->open(PROPOSAL_FILE_DIR . "{$file["proposal"]}.zip", ZipArchive::RDONLY);
			$fp = $zip2->getStream($file["filename"]);
			$zip->addFromString($file["filename"], stream_get_contents($fp));
			fclose($fp);
			$zip2->close();
		}
		$zip->close();
		$fp = fopen($zipFile, "r");
		$v = new StreamView($fp, "application/zip");
		fclose($fp);
		unlink($zipFile);
		@Logger::record($db, "ダウンロード", ["files" => $_POST["filenames"]]);
		return $v;
	}
}