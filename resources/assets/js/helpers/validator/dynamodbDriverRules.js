import store from "../../../store";

import {Validator} from "../easy-validator";

import {lang} from "../extraLogics";

export function validateDynamoDriver(data) {

    const {endpoint ,key ,region , secret, table} = data

    let validatingData = {

        endpoint: [endpoint, 'isRequired'],

        key: [key, 'isRequired'],

        region: [region, 'isRequired'],

        secret: [secret, 'isRequired'],

        table: [table, 'isRequired'],
    };

    const validator = new Validator(lang);

    const { errors, isValid } = validator.validate(validatingData);

    store.dispatch('setValidationError', errors);

    return { errors, isValid };
}