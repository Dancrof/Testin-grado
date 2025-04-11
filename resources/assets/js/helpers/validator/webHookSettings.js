import store from "../../../store";

import {Validator} from "../easy-validator";

import {lang} from "../extraLogics";

export function validateWebhookData(data) {

    const {web_hook} = data

    let validatingData = {

        web_hook: [web_hook, 'isRequired'],
    };

    const validator = new Validator(lang);

    const { errors, isValid } = validator.validate(validatingData);

    store.dispatch('setValidationError', errors);

    return { errors, isValid };
}