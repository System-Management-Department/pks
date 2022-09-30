<?php
namespace Config;

class MySqlConnection{
	public static function __callStatic($name, $arguments){
		return ['localhost', 'admin', 'wgydLL9cnvWJ', 'pks'];
	}
	
	public static function auth(){
		/** ユーザー認証 */
		return ['localhost', 'auth', 'rN0xGR4A8VcC', 'pks'];
	}
	
	public static function admin(){
		/** 管理者 */
		return ['localhost', 'admin', 'wgydLL9cnvWJ', 'pks'];
	}
	
	public static function entry(){
		/** 編集 */
		return ['localhost', 'entry', 'LGppHQWRfqg3', 'pks'];
	}
	
	public static function browse(){
		/** 閲覧 */
		return ['localhost', 'browse', 'tCEqPFXC4NJV', 'pks'];
	}
}