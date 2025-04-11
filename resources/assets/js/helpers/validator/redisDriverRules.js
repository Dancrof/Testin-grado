import store from "../../../store";

import {Validator} from "../easy-validator";

import {lang} from "../extraLogics";

export function validateRedisDriver(data) {

    const { connection} = data

    let validatingData = {

        connection: [connection, 'isRequired'],
    };

    const validator = new Validator(lang);

    const { errors, isValid } = validator.validate(validatingData);

    store.dispatch('setValidationError', errors);

    return { errors, isValid };
}