<?php
namespace App\Master;
class Data{
	private static $cache = [];
	private static $path = __DIR__ . DIRECTORY_SEPARATOR . "Data" . DIRECTORY_SEPARATOR;
	public static function __callStatic($name, $arguments){
		if(\array_key_exists($name, self::$cache)){
			return self::$cache[$name];
		}
		$includeFileName = self::$path . "{$name}.php";
		if(\file_exists($includeFileName)){
			self::$cache[$name] = include $includeFileName;
			return self::$cache[$name];
		}
		return [];
	}
	
	public static function import($name, $data){
		$fileContents = '<?php return ' . \var_export($data, true) . ';';
		\file_put_contents(self::$path . "{$name}.php", $fileContents);
	}
}