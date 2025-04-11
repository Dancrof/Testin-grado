import store from '../../../store'

import {Validator} from "../easy-validator";

import {lang} from '../extraLogics';

export function validateOauthFormFields(data)
{
    const { app_name,callback_url, homepage_url } = data;

    let validatingData = {

        app_name: [app_name, 'isRequired'],

        callback_url: [callback_url, 'isRequired'],

        homepage_url: [homepage_url, 'isRequired'],
    };

    const validator = new Validator(lang);

    const {errors, isValid} = validator.validate(validatingData);

    store.dispatch('setValidationError', errors); //if component is valid, an empty state will be sent

    return {errors, isValid};
}