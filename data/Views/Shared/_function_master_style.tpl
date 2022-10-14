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
	border: 1px solid darkgray;
}
#headergrid *{
	padding: 10px;
}
#datagrid{
	border-left: 1px solid darkgray;
	border-right: 1px solid darkgray;
	border-bottom: 1px solid darkgray;
}
#datagrid .gridrow{
	display: none;
}
#datagrid .gridrow.odd{
	--row-color: lightgray;
}
#datagrid .gridrow.even{
	--row-color: white;
}
#datagrid .gridrow:hover{
	--row-color: yellow;
}
#datagrid .griddata{
	background: var(--row-color);
	padding: 10px;
}
#datagrid .griddata:first-child{
	grid-column: 1;
}
{/literal}</style>
{/function}