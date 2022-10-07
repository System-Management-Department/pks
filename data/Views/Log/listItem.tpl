{foreach from=$logs item="log"}{assign var="data" value=$log.data|json_decode:true}
<div class="gridrow">
	<div class="griddata">{$log.datetime}</div>
	<div class="griddata">{$log.control}</div>
	<div class="griddata">{if "files"|array_key_exists:$data}{foreach from=$data.files item="file"}
		<div>{$file}</div>
	{/foreach}{/if}</div>
	<div class="griddata">{$log.username}</div>
</div>
{/foreach}
<input type="hidden" name="lastdata" value="{$lastdata}" />{javascript_notice}