<?php
namespace App;
use ArrayAccess;
use Model\Result;

class Validator implements ArrayAccess{
	private $container;
	public function __construct(){
		$this->container = [];
	}
	
	/**
		入力値を検証
	*/
	public function __invoke($a1, $a2 = null){
		if($a1 instanceof Result){
			// Resultへ追加する場合
			$result = &$a1;
			$assoc = &$a2;
		}else{
			// Resultのインスタンスを新しく生成する場合
			$result = new Result();
			$assoc = &$a1;
		}
		foreach($this->container as $k => $v){
			$v($result, array_key_exists($k, $assoc) ? $assoc[$k] : null);
		}
		return $result;
	}
	
	#[\ReturnTypeWillChange]
	public function offsetSet($offset, $value){
	}
	
	#[\ReturnTypeWillChange]
	public function offsetExists($offset){
		return isset($this->container[$offset]);
	}
	
	#[\ReturnTypeWillChange]
	public function offsetUnset($offset){
		unset($this->container[$offset]);
	}
	
	#[\ReturnTypeWillChange]
	public function offsetGet($offset){
		if(!array_key_exists($offset, $this->container)){
			$this->container[$offset] = new ValidationItem();
		}
		return $this->container[$offset];
	}
}

class ValidationItem{
	private $emptyMessage;
	private $pattern;
	private $ranges;
	
	public function __construct(){
		$this->emptyMessage = null;
		$this->pattern = null;
		$this->ranges = [];
	}
	
	/**
		検証
	*/
	public function __invoke($result, $value){
		if(is_null($this->emptyMessage)){
			if(is_null($value) || $value == ""){
				return;
			}
		}else{
			// required
			if(is_null($value) || $value == ""){
				$result->addMessage($this->emptyMessage, "ERROR");
			}
		}
		foreach($this->ranges as $k => $v){
			$isIn = true;
			if(is_null($v["in"])){
				// 区間
				if(!is_null($v["gt"])){
					$isIn = $isIn && ($v > $v["gt"]);
				}
				if(!is_null($v["ge"])){
					$isIn = $isIn && ($v >= $v["ge"]);
				}
				if(!is_null($v["lt"])){
					$isIn = $isIn && ($v < $v["lt"]);
				}
				if(!is_null($v["le"])){
					$isIn = $isIn && ($v <= $v["le"]);
				}
			}else{
				// 集合
				$isIn = in_array($v, $v["in"]);
			}
			if($v["not"]){
				if($isIn){
					$result->addMessage($v["message"], "ERROR");
					break;
				}
			}else{
				if(!$isIn){
					$result->addMessage($v["message"], "ERROR");
					break;
				}
			}
		}
	}
	
	/**
		必須
	*/
	public function required($message){
		$this->emptyMessage = $message;
		return $this;
	}
	
	/**
		有効範囲
		range("{0,1,2,5}に含まれる", "in", [0, 1, 2, 5])
		range("{0,1,2,5}に含まれない", "not in", [0, 1, 2, 5])
		range("0を超える10未満", "(a,b)", ["a" => 0, "b" => 10])
		range("0以上10以下", "[a,b]", ["a" => 0, "b" => 10])
	*/
	public function range($message, $rangeStr, $rangeParams){
		preg_match('/^(?:\\s*(?<not>not))?\\s*(?:(?<in>in)|(?<min>[\\(\\[])\\s*(?<v1>[a-zA-Z][a-zA-Z0-9]*)\\s*,\\s*(?<v2>[a-zA-Z][a-zA-Z0-9]*)\\s*(?<max>[\\)\\]]))\\s*$/', $rangeStr, $matches, PREG_UNMATCHED_AS_NULL);
		if(!empty($matches)){
			$rangeItem = [
				"message" => $message,
				"not" => !is_null($matches["not"]),
				"gt" => null,
				"ge" => null,
				"lt" => null,
				"le" => null,
				"in" => null,
			];
			if(is_null($matches["in"])){
				$k = ($matches["min"] == "(") ? "gt" : "ge";
				$rangeItem[$k] = array_key_exists($matches["v1"], $rangeParams) ? $rangeParams[$matches["v1"]] : null;
				$k = ($matches["max"] == ")") ? "lt" : "le";
				$rangeItem[$k] = array_key_exists($matches["v2"], $rangeParams) ? $rangeParams[$matches["v2"]] : null;
			}else{
				$rangeItem["in"] = $rangeParams;
			}
			$this->ranges[] = $rangeItem;
		}
		return $this;
	}
}