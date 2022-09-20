<?php
namespace App;
use mysqli;

class MySQL{
	private $mysqli;
	public function __construct(){
		$this->mysqli = new mysqli('localhost', 'root', 'root', 'pks');
	}
	public function __destruct(){
		$this->mysqli->close();
	}
	public function select(){
		return new MySQLSelectQuery($this->mysqli);
	}
}

class MySQLSelectQuery{
	private $mysqli;
	private $prepare;
	private $bindParam;
	private const SELECT= 0;
	private const TABLE = 1;
	private const WHERE = 2;
	private const GROUP_BY = 3;
	private const HAVING = 4;
	private const ORDER_BY = 5;
	private const LIMIT = 6;
	private const OFFSET = 7;
	
	public function __construct($mysqli){
		$this->mysqli = $mysqli;
		$this->prepare = [null, null, null, null, null, null, null, null];
		$this->bindParam = [[], [], [], [], [], [], [], []];
	}
	public function __invoke(){
		$q = $this->buildQuery();
		$stmt = $this->mysqli->prepare($q["prepare"]);
		$bindVars = [&$types];
		$types = "";
		foreach($q["bind"] as &$bind){
			$types .= $bind["type"];
			$bindVars[] = &$bind["value"];
		}
		if($types != ""){
			$stmt->bind_param(...$bindVars);
		}
		$stmt->execute();
		$result = $stmt->get_result();
		return $result->fetch_all(MYSQLI_ASSOC);
	}
	public function setField($field, ...$bind){
		$this->prepare[self::SELECT] = $field;
		$this->bindParam[self::SELECT] = $bind;
		return $this;
	}
	public function setTable($table, ...$bind){
		$this->prepare[self::TABLE] = $table;
		$this->bindParam[self::TABLE] = $bind;
		return $this;
	}
	public function setWhere($where, ...$bind){
		$this->prepare[self::WHERE] = $where;
		$this->bindParam[self::WHERE] = $bind;
		return $this;
	}
	public function setGroupBy($field, ...$bind){
		$this->prepare[self::GROUP_BY] = $field;
		$this->bindParam[self::GROUP_BY] = $bind;
		return $this;
	}
	public function setHaving($where, ...$bind){
		$this->prepare[self::HAVING] = $where;
		$this->bindParam[self::HAVING] = $bind;
		return $this;
	}
	public function setOrderBy($field, ...$bind){
		$this->prepare[self::ORDER_BY] = $field;
		$this->bindParam[self::ORDER_BY] = $bind;
		return $this;
	}
	public function setLimit($limit, ...$bind){
		$this->prepare[self::LIMIT] = $limit;
		$this->bindParam[self::LIMIT] = $bind;
		return $this;
	}
	public function setOffset($offset, ...$bind){
		$this->prepare[self::OFFSET] = $offset;
		$this->bindParam[self::OFFSET] = $bind;
		return $this;
	}
	
	
	public function addField($field, ...$bind){
		if(is_null($this->prepare[self::SELECT])){
			$this->prepare[self::SELECT] = $field;
			$this->bindParam[self::SELECT] = $bind;
		}else{
			$this->prepare[self::SELECT] .= "," . $field;
			$this->bindParam[self::SELECT] = array_merge($this->bindParam[self::SELECT], $bind);
		}
		return $this;
	}
	public function addTable($table, ...$bind){
		if(is_null($this->prepare[self::TABLE])){
			$this->prepare[self::TABLE] = $table;
			$this->bindParam[self::TABLE] = $bind;
		}else{
			$this->prepare[self::TABLE] .= "," . $table;
			$this->bindParam[self::TABLE] = array_merge($this->bindParam[self::TABLE], $bind);
		}
		return $this;
	}
	public function leftJoin($table, ...$bind){
		if(is_null($this->prepare[self::TABLE])){
			$this->prepare[self::TABLE] = $table;
			$this->bindParam[self::TABLE] = $bind;
		}else{
			$this->prepare[self::TABLE] .= " LEFT JOIN " . $table;
			$this->bindParam[self::TABLE] = array_merge($this->bindParam[self::TABLE], $bind);
		}
		return $this;
	}
	public function rightJoin($table, ...$bind){
		if(is_null($this->prepare[self::TABLE])){
			$this->prepare[self::TABLE] = $table;
			$this->bindParam[self::TABLE] = $bind;
		}else{
			$this->prepare[self::TABLE] .= " RIGHT JOIN " . $table;
			$this->bindParam[self::TABLE] = array_merge($this->bindParam[self::TABLE], $bind);
		}
		return $this;
	}
	public function innerJoin($table, ...$bind){
		if(is_null($this->prepare[self::TABLE])){
			$this->prepare[self::TABLE] = $table;
			$this->bindParam[self::TABLE] = $bind;
		}else{
			$this->prepare[self::TABLE] .= " INNER JOIN " . $table;
			$this->bindParam[self::TABLE] = array_merge($this->bindParam[self::TABLE], $bind);
		}
		return $this;
	}
	public function andWhere($where, ...$bind){
		if(is_null($this->prepare[self::WHERE])){
			$this->prepare[self::WHERE] = $where;
			$this->bindParam[self::WHERE] = $bind;
		}else{
			$this->prepare[self::WHERE] .= " AND " . $where;
			$this->bindParam[self::WHERE] = array_merge($this->bindParam[self::WHERE], $bind);
		}
		return $this;
	}
	public function orWhere($where, ...$bind){
		if(is_null($this->prepare[self::WHERE])){
			$this->prepare[self::WHERE] = $where;
			$this->bindParam[self::WHERE] = $bind;
		}else{
			$this->prepare[self::WHERE] .= " OR " . $where;
			$this->bindParam[self::WHERE] = array_merge($this->bindParam[self::WHERE], $bind);
		}
		return $this;
	}
	
	private function buildQuery(){
		$prepare = "SELECT ";
		$bind = [];
		if(is_null($this->prepare[self::SELECT])){
			$prepare .= "*";
		}else{
			$prepare .= trim($this->prepare[self::SELECT]);
			$this->mergeBindParam($bind, self::SELECT);
		}
		if(!is_null($this->prepare[self::TABLE])){
			$prepare .= " FROM " . trim($this->prepare[self::TABLE]);
			$this->mergeBindParam($bind, self::TABLE);
		}
		if(!is_null($this->prepare[self::WHERE])){
			$prepare .= " WHERE " . trim($this->prepare[self::WHERE]);
			$this->mergeBindParam($bind, self::WHERE);
		}
		if(!is_null($this->prepare[self::GROUP_BY])){
			$prepare .= " GROUP BY " . trim($this->prepare[self::GROUP_BY]);
			$this->mergeBindParam($bind, self::GROUP_BY);
		}
		if(!is_null($this->prepare[self::HAVING])){
			$prepare .= " HAVING " . trim($this->prepare[self::HAVING]);
			$this->mergeBindParam($bind, self::HAVING);
		}
		if(!is_null($this->prepare[self::ORDER_BY])){
			$prepare .= " ORDER BY " . trim($this->prepare[self::ORDER_BY]);
			$this->mergeBindParam($bind, self::ORDER_BY);
		}
		if(!is_null($this->prepare[self::LIMIT])){
			$prepare .= " LIMIT " . trim($this->prepare[self::LIMIT]);
			$this->mergeBindParam($bind, self::LIMIT);
		}
		if(!is_null($this->prepare[self::OFFSET])){
			$prepare .= " OFFSET " . trim($this->prepare[self::OFFSET]);
			$this->mergeBindParam($bind, self::OFFSET);
		}
		
		return ["prepare" => $prepare, "bind" => $bind];
	}
	private function mergeBindParam(&$bind, $index){
		foreach($this->bindParam[$index] as $value){
			$type = "s";
			if(is_int($value)){
				$type = "i";
			}else if(is_float($value)){
				$type = "d";
			}
			$bind[] = ["type" => $type, "value" => $value];
		}
	}
}