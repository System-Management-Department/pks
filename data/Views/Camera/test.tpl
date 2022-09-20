{block name="scripts" append}
<script type="text/javascript">{literal}
document.addEventListener("DOMContentLoaded", () => {
	let video = document.querySelector('video');
	let mediaRecorder = null;
	let recordedData = [];
	video.addEventListener("click", () => {
		if(video.srcObject == null && video.querySelector('source') == null){
			navigator.mediaDevices.getUserMedia({audio: true, video: true}).then(mediaStream => {
				mediaRecorder = new MediaRecorder(mediaStream, {
					mimeType: 'video/webm;codecs=vp8',
					audioBitsPerSecond: 16 * 1000
				});
				
				mediaRecorder.addEventListener("dataavailable", e => {
					recordedData.push(e.data);
				});
				mediaRecorder.addEventListener("stop", () => {
					let blob = new Blob(recordedData , {type: "video/webm;codecs=vp8"});
					let source = document.createElement("source");
					source.setAttribute("src", URL.createObjectURL(blob));
					source.setAttribute("type", "video/webm");
					video.appendChild(source);
				});
				
				video.srcObject = mediaStream;
				video.onloadedmetadata = function(e) {
					mediaRecorder.start();
					video.play();
				};
			});
		}
	});
	video.addEventListener("pause", function(){
		if(video.srcObject != null){
			let stream = video.srcObject;
			let tracks = stream.getTracks();
			mediaRecorder.stop()
			tracks.forEach(function(track) {
				track.stop();
			});
			video.srcObject = null;
		}
	});
});
{/literal}</script>
{/block}

{block name="body"}
<video autoplay controls playsinline></video>
{/block}