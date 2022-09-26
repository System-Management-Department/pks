{foreach $proposals item="proposal"}
<label class="d-contents">
	<input type="radio" name="proposal" />
	<div class="thumbnail" style="background-image: url('/file/thumbnail/{$proposal.id}.png');">
	{foreach "/"|explode:$proposal.files item="data"}
		<a href="/file/data/{$data}"></a>
	{/foreach}
	</div>
</label>
{/foreach}
<input type="hidden" name="lastdata" value="{$lastdata}" />