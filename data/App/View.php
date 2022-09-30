<?php
namespace App;
use ArrayAccess;
use Iterator;

class View implements ArrayAccess, Iterator, IView{
	private $container;
	private $controller;
	private $action;
	private $layout;
	public function __construct(){
		$this->container = [];
		$this->controller = null;
		$this->action = null;
		$this->layout = "Shared" . DIRECTORY_SEPARATOR . "_layout.tpl";
	}
	
	public function __invoke($requestContext, $return = true){
		$smarty = new Smarty($requestContext);
		$smarty
			->setCacheDir(dirname(DATA_DIR) . DIRECTORY_SEPARATOR . 'cache' . DIRECTORY_SEPARATOR . 'templates_c')
			->setCompileDir(dirname(DATA_DIR) . DIRECTORY_SEPARATOR . 'cache' . DIRECTORY_SEPARATOR . 'templates')
			->addPluginsDir(DATA_DIR . 'App' . DIRECTORY_SEPARATOR . 'Smarty' . DIRECTORY_SEPARATOR . 'plugins');
		$template = DATA_DIR . 'Views' . DIRECTORY_SEPARATOR .
			str_replace("\\", DIRECTORY_SEPARATOR, is_null($this->controller) ? $requestContext->controller : $this->controller) . DIRECTORY_SEPARATOR .
			(is_null($this->action) ? $requestContext->action : $this->action) . ".tpl";
		if(!is_null($this->layout)){
			$template = "extends:" . DATA_DIR . "Views" . DIRECTORY_SEPARATOR . "{$this->layout}|{$template}";
		}
		$smarty->assign($this->container);
		
		if($return){
			return $smarty->fetch($template);
		}else{
			$smarty->display($template);
		}
	}
	
	#[\ReturnTypeWillChange]
	public function offsetSet($offset, $value){
		if(is_null($offset)){
			$this->container[] = $value;
		}else{
			$this->container[$offset] = $value;
		}
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
		return isset($this->container[$offset]) ? $this->container[$offset] : null;
	}
	
	#[\ReturnTypeWillChange]
	public function rewind(){
		\reset($this->container);
	}
	
    #[\ReturnTypeWillChange]
    public function current(){
        return \current($this->container);
    }
    
    #[\ReturnTypeWillChange]
    public function key(){
        return \key($this->container);
    }
    
    #[\ReturnTypeWillChange]
	public function next(){
		 \next($this->container);
	}
    
    #[\ReturnTypeWillChange]
	public function valid(){
		$key = \key($this->container);
		return !is_null($key);
	}
    
    public function assign($assoc){
    	foreach($assoc as $k => $v){
    		$this->container[$k] = $v;
    	}
    }
    
    public function setController($controller){
    	$this->controller = $controller;
    	return $this;
    }
    
    public function setAction($action){
    	$this->action = $action;
    	return $this;
    }
    
    public function setLayout($layout){
    	$this->layout = $layout;
    	return $this;
    }
    
}