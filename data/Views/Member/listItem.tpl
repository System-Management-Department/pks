{foreach from=$proposals item="proposal"}
<label class="d-contents">
	<input type="radio" value="{$proposal.id}" name="proposal" />
	<div class="thumbnail" style="background-image: url('/file/thumbnail/{$proposal.id}.png');"
		data-editable="{if $proposal.author eq $smarty.session["User.id"]}true{else}false{/if}"
		data-keyword="{$proposal.keywords}"
		data-targets="{foreach from=","|explode:$proposal.targets item="code"}{$targets[$code].name} {/foreach}"
		data-medias="{foreach from=","|explode:$proposal.medias item="code"}{$medias[$code].name} {/foreach}"
		data-modified-date="{$proposal.modified_date}"
		data-client="{$clients[$proposal.client].name}"
		data-product-name="{$proposal.product_name}"
	>
	{if not $proposal.filename|is_null}{foreach $proposal.filename|json_decode:true item="data"}
		<a href="{url controller="Archive" action="proposal" id=$data.filename}" data-type="{$data.type}"></a>
	{/foreach}{/if}
	</div>
</label>
{/foreach}
<input type="hidden" name="lastdata" value="{$lastdata}" />{javascript_notice}