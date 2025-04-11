import store from '../../../store'

import {Validator} from "../easy-validator";

import {lang} from '../extraLogics';

export function validateOAuthSetting(data) {

    const { client_id, client_secret } = data

    var validatingData = {

        client_id: [client_id, 'isRequired'],

        client_secret: [client_secret, 'isRequired'],
    };

    const validator = new Validator(lang);

    const { errors, isValid } = validator.validate(validatingData);

    store.dispatch('setValidationError', errors); //if component is valid, an empty state will be sent

    return { errors, isValid };
}