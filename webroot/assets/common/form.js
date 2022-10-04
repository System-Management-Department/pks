document.addEventListener("DOMContentLoaded", function(){
	let changeSelectEvent = e => {
		let select = e.currentTarget;
		if(select.value == ""){
			select.value = "";
		}
	};
	for(let input of document.querySelectorAll('select.form-select')){
		input.addEventListener("change", changeSelectEvent);
	}

});