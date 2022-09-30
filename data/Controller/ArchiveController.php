<?php
namespace Controller;
use App\ControllerBase;
use App\StreamView;
use Model\Session;

class ArchiveController extends ControllerBase{
	public function proposal(){
		$db = Session::getDB();
		$query = $db->select("ROW")
			->addTable("files")
			->andWhere("filename=?", $this->requestContext->id);
		$file = $query();
		$zip = new \ZipArchive();
		$zip->open(PROPOSAL_FILE_DIR . "{$file["proposal"]}.zip", \ZipArchive::RDONLY);
		$fp = $zip->getStream($this->requestContext->id);
		$v = new StreamView($fp, $file["type"]);
		fclose($fp);
		$zip->close();
		return $v;
	}
}