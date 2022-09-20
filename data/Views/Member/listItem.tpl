{foreach $fileList item="file"}
<label class="d-contents">
	<input type="radio" name="proposal" />
	<div class="thumbnail" style="background-image: url('{$file.thumbnail}');">
	{foreach $file.data item="data"}
		<a href="{$data}"></a>
	{/foreach}
	</div>
</label>
{/foreach}
<input type="hidden" name="lastdata" value="{$lastdata}" />