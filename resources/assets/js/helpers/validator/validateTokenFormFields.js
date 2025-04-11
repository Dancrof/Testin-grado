import store from '../../../store'

import {Validator} from "../easy-validator";

import {lang} from '../extraLogics';

export function validateTokenForm(data)
{
    const { name, expiry, start_date, end_date } = data;

    let validatingData = {

        name: [name, 'isRequired'],

        expiry: [expiry, 'isRequired'],
    };

    if (data.expiry === 'custom') {

        validatingData['end_date'] = [end_date, 'isRequired'];
    }

    const validator = new Validator(lang);

    const {errors, isValid} = validator.validate(validatingData);

    store.dispatch('setValidationError', errors); //if component is valid, an empty state will be sent

    return {errors, isValid};
}

export function validateReTokenForm(data)
{
    const { expiry, end_date } = data;

    let validatingData = {

        expiry: [expiry, 'isRequired'],
    };

    if (data.expiry === 'custom') {

        validatingData['end_date'] = [end_date, 'isRequired'];
    }

    const validator = new Validator(lang);

    const {errors, isValid} = validator.validate(validatingData);

    store.dispatch('setValidationError', errors); //if component is valid, an empty state will be sent

    return {errors, isValid};
}