document.addEventListener("DOMContentLoaded", function(){
	let changeSelectEvent = e => {
		let select = e.currentTarget;
		if(select.value == ""){
			select.value = "";
		}
	};
	for(let input of document.querySelectorAll('select.form-control')){
		input.addEventListener("change", changeSelectEvent);
	}

});