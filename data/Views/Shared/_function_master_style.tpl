{function name="shared_masterStyle" columns="1fr"} 
<style type="text/css">{literal}
#mainlist{
	overflow-y: auto;
}
#headergrid,#datagrid{
	display: grid;
	grid-template-columns: {/literal}{$columns}{literal};
	grid-auto-rows: auto;
}
#headergrid{
	position: sticky;
	top: 0;
	background: white;
	border: 1px solid #c7d0d7;
}
#headergrid *{
	padding: 6px;
}
#datagrid{
	border-left: 1px solid #c7d0d7;
	border-right: 1px solid #c7d0d7;
	border-bottom: 1px solid #c7d0d7;
}
#datagrid .gridrow{
	display: none;
}
#datagrid .gridrow.odd{
	--row-color: #f0f3f5;
}
#datagrid .gridrow.even{
	--row-color: white;
}
#datagrid .gridrow:hover{
	--row-color: #fffcd6;
}
#datagrid .griddata{
	background: var(--row-color);
	padding: 6px;
	word-break: break-all;
}
#datagrid .griddata:first-child{
	grid-column: 1;
}
#datagrid .griddata [data-bs-toggle="modal"][data-bs-target]{
	cursor: pointer;
}
{/literal}</style>
{/function}