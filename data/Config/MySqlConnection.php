<?php
namespace Config;

class MySqlConnection{
	public static function __callStatic($name, $arguments){
		return ['localhost', 'root', 'root', 'pks'];
	}
	
	public static function admin(){
		/**
			CREATE USER 'admin'@'localhost' IDENTIFIED BY 'wgydLL9cnvWJ';
			GRANT SELECT,INSERT,DELETE,UPDATE ON pks.* TO 'admin'@'localhost';
		*/
		return ['localhost', 'admin', 'wgydLL9cnvWJ', 'pks'];
	}
	
	public static function entry(){
		/**
			CREATE USER 'entry'@'localhost' IDENTIFIED BY 'LGppHQWRfqg3';
			GRANT SELECT,INSERT,DELETE,UPDATE ON pks.* TO 'entry'@'localhost';
		*/
		return ['localhost', 'entry', 'LGppHQWRfqg3', 'pks'];
	}
	
	public static function browse(){
		/**
			CREATE USER 'browse'@'localhost' IDENTIFIED BY 'tCEqPFXC4NJV';
			GRANT SELECT ON pks.* TO 'browse'@'localhost';
		*/
		return ['localhost', 'browse', 'tCEqPFXC4NJV', 'pks'];
	}
}