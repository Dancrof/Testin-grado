import store from "../../../store";

import {Validator} from "../easy-validator";

import {lang} from "../extraLogics";

export function validateMemcachedDriver(data) {

    const {host ,port} = data

    let validatingData = {

        host: [host, 'isRequired'],

        port: [port, 'isRequired'],

    };

    const validator = new Validator(lang);

    const { errors, isValid } = validator.validate(validatingData);

    store.dispatch('setValidationError', errors);

    return { errors, isValid };
}