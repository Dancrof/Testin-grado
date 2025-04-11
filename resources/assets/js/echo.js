import Echo from 'laravel-echo';
import Pusher from 'pusher-js';
import axios from 'axios';

window.Pusher = Pusher;

if (window.socketsEnabled) {
    axios.get('api/get/socket-driver/reverb').then(response => {
        const config = response.data.data;

        window.Echo = new Echo({
            broadcaster: 'reverb',
            key: config.reverb_app_key,
            wsHost: config.reverb_host,
            wsPort: config.reverb_server_port,
            wssPort: config.reverb_port,
            forceTLS: true,
            enabledTransports: ['ws', 'wss'],
        });
    }).catch(error => {
        console.info('Error fetching Reverb config:', error);
    });
}
