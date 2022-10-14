{foreach from=$proposals item="proposal"}
<label class="d-contents">
	<input type="radio" value="{$proposal.id|escape:"html"}" name="proposal" />
	<div class="thumbnail" style="background-image: url('/file/thumbnail/{$proposal.id|escape:"html"}.png');"
		data-editable="{if $proposal.author eq $smarty.session["User.id"]}true{else}false{/if}"
		data-keyword="{$proposal.keywords|escape:"html"}"
		data-targets="{foreach from=","|explode:$proposal.targets item="code"}{$targets[$code].name|escape:"html"} {/foreach}"
		data-medias="{foreach from=","|explode:$proposal.medias item="code"}{$medias[$code].name|escape:"html"} {/foreach}"
		data-modified-date="{$proposal.modified_date|escape:"html"}"
		data-client="{$clients[$proposal.client].name|escape:"html"}"
		data-product-name="{$proposal.product_name|escape:"html"}"
	>
	{if not $proposal.filename|is_null}{foreach $proposal.filename|json_decode:true item="data"}
		<a href="{url controller="Archive" action="proposal" id=$data.filename}" data-type="{$data.type|escape:"html"}"></a>
	{/foreach}{/if}
	</div>
</label>
{/foreach}
<input type="hidden" name="lastdata" value="{$lastdata|escape:"html"}" />{javascript_notice}