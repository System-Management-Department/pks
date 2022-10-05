<?php
namespace Model;
use App\Validator;

class Log{
	public static function record($db, $q){
		$insertQuery = $db->insertSet("logs", [
			"proposal" => $q["proposal"],
			"control" => $q["control"],
			"filename" => $q["filename"],
		],[
			"user" => "@user",
			"username" => "@username",
			"datetime" => "now()",
		]);
		$insertQuery($id);
	}
}