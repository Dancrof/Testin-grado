@if(socketsEnabled('pusher'))
<script src="{{assetLink('js','laravel-echo')}}"></script>
<script src="{{assetLink('js','pusher')}}"></script>
<script type="text/javascript">
	let host = ["localhost", "127.0.0.1"].includes('{{config('websockets.host')}}')?window.location.hostname:'{{config('websockets.host')}}';
	let sslEnforce = true;
	window.Echo = new Echo({
	    broadcaster: 'pusher',
	        key: '{{config('broadcasting.connections.pusher.key')}}',
  			cluster: '{{config('broadcasting.connections.pusher.options.cluster')}}',
  			wsHost: host,
  			wsPort:'{{config('websockets.port')}}',
  			wssPort:'{{config('websockets.port')}}',
  			disableStats: true,
  			forceTLS: sslEnforce
	});
</script>
@endif