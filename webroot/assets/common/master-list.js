document.addEventListener("DOMContentLoaded", function(){
	const additionalStyle = document.getElementById("additionalStyle");
	const styleSheet = additionalStyle.sheet;
	let n = styleSheet.cssRules.length;
	let mainlist = document.getElementById("mainlist");
	let rect = mainlist.getBoundingClientRect();
	styleSheet.insertRule(`#mainlist{
		height: calc(100vh - ${rect.y + window.pageYOffset}px - 1.5rem);
	}`, n++);
	
	let filter = n;
	styleSheet.insertRule(`#datagrid .gridrow[data-filter]{
		display: contents;
	}`, n++);
	let container = document.getElementById("filter");
	container.querySelector('button').addEventListener("click", e => {
		let value = CSS.escape(container.querySelector('input').value);
		let attr = (value == "") ? "data-filter" : `data-filter*="${value}"`;
		let selector = `#datagrid .gridrow[${attr}]`;
		styleSheet.cssRules[filter].selectorText = selector;
		Array.prototype.forEach.call(document.querySelectorAll(selector), (e, i) => {
			let odd = (i % 2) == 0;
			e.classList.add(odd ? "odd" : "even");
			e.classList.remove(odd ? "even" : "odd");
		});
	});
	
	let form = document.getElementById("deleteModal");
	if(form != null){
		let deleteMap = new Map();
		let headers = [];
		let deleteModal = e => {
			let dataList = deleteMap.get(e.currentTarget);
			let body = form.querySelector('.modal-body');
			body.innerHTML = "";
			let n = headers.length;
			for(let i = 0; i < n; i++){
				let header = document.createElement("div");
				let data = document.createElement("div");
				header.textContent = headers[i];
				data.textContent = dataList[i];
				if(i > 0){
					header.setAttribute("class", "fw-bold small mt-3");
				}else{
					header.setAttribute("class", "fw-bold small");
				}
				data.setAttribute("class", "mx-3");
				body.appendChild(header);
				body.appendChild(data);
			}
			form.querySelector('[name="id"]').value = e.currentTarget.getAttribute("data-id");
		};
		let headergrid = document.querySelector('#headergrid').childNodes;
		for(let node of headergrid){
			if(node.nodeType == Node.ELEMENT_NODE && node.textContent != ""){
				headers.push(node.textContent);
			}
		}
		n = headers.length;
		let rows = document.querySelectorAll('#datagrid .gridrow');
		for(let row of rows){
			let dataList = [];
			let datas = row.querySelectorAll('.griddata');
			for(let i = 0; i < n; i++){
				dataList.push(datas[i].textContent);
			}
			let deleteBtn = row.querySelector('[data-bs-target="#deleteModal"]');
			if(deleteBtn == null){
				continue;
			}
			deleteMap.set(deleteBtn, dataList);
			deleteBtn.addEventListener("click", deleteModal);
		}
		
		form.addEventListener("submit", e => {
			e.stopPropagation();
			e.preventDefault();
			let formData = new FormData(form);
			
			fetch(form.getAttribute("action"), {
				method: form.getAttribute("method"),
				body: formData
			}).then(res => res.json()).then(json => {
				if(json.success){
					Storage.pushToast(form.getAttribute("data-master"), json.messages);
					location.reload()
				}else{
				}
			});
		});
	}
	
	let uploadFiles = document.querySelectorAll('input[type="file"][formaction]');
	let upload = e => {
		let input = e.currentTarget;
		if(input.files.length == 1){
			let formData = new FormData();
			formData.append("data", input.files[0], input.files[0].name);
			fetch(input.getAttribute("formaction"), {
				method: "POST",
				body: formData
			}).then(res => res.json()).then(json => {
				Storage.pushToast("マスター管理", json.messages);
				location.reload();
			});
		}
	};
	for(let input of uploadFiles){
		input.addEventListener("change", upload);
	}
});