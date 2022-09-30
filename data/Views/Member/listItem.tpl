{foreach $proposals item="proposal"}
<label class="d-contents">
	<input type="radio" value="{$proposal.id}" name="proposal" />
	<div class="thumbnail" style="background-image: url('/file/thumbnail/{$proposal.id}.png');">
	{if not $proposal.filename|is_null}{foreach $proposal.filename|json_decode:true item="data"}
		<a href="{url controller="Archive" action="proposal" id=$data.filename}" data-type="{$data.type}"></a>
	{/foreach}{/if}
	</div>
</label>
{/foreach}
<input type="hidden" name="lastdata" value="{$lastdata}" />