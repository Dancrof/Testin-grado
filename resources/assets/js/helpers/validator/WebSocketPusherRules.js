import store from "../../../store";

import {Validator} from "../easy-validator";

import {lang} from "../extraLogics";
export function validatePusherDriver(data) {
    let {
        websocket_server_host,
        websocket_server_port,
        pusher_app_id,
        pusher_app_key,
        pusher_app_secret,
        pusher_app_cluster,
    } = data;

    let validatingData = {
        websocket_server_host: [websocket_server_host, "isRequired"],
        websocket_server_port: [websocket_server_port, "isRequired"],
        pusher_app_id: [pusher_app_id, "isRequired"],
        pusher_app_key: [pusher_app_key, "isRequired"],
        pusher_app_secret: [pusher_app_secret, "isRequired"],
        pusher_app_cluster: [pusher_app_cluster, "isRequired"],
    };

    const validator = new Validator(lang);

    const { errors, isValid } = validator.validate(validatingData);

    store.dispatch('setValidationError', errors);

    return { errors, isValid };
}
