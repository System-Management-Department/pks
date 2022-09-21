<?php
namespace Model;
use JsonSerializable;

class Result implements JsonSerializable{
	private $success;
	private $messages;
	private $data;
	
	public function __construct(){
		$this->success = true;
		$this->messages = [];
		$this->data = null;
	}
	
	public function setData($data){
		$this->data = $data;
		return $this;
	}
	
	public function addMessage($message, $type = "INFO"){
		$type2 = strtoupper($type);
		$status = match(true){
			($type2 == "ERROR") => 2,
			($type2 == "WARN") => 1,
			default => 0,
		};
		if(!is_null($message)){
			$this->messages[] = [$message, $status];
		}
		if($status == 2){
			$this->success = false;
		}else if($status == 1 && $this->success !== false){
			$this->success = null;
		}
		return $this;
	}
	
	public function hasError(){
		return $this->success === false;
	}
	
	#[\ReturnTypeWillChange]
	public function jsonSerialize(){
		return [
			"success" => $this->success,
			"messages" => $this->messages,
			"data" => $this->data
		];
	}
}