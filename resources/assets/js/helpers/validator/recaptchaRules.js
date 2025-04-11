import store from '../../../store'

import {Validator} from "../easy-validator";

import {lang} from '../extraLogics';

export function validateReCaptchaSettings(data){

    const { googleServiceKey, googleSecretKey } = data;

    let validatingData = {

        googleServiceKey: [googleServiceKey, 'isRequired'],

        googleSecretKey: [googleSecretKey, 'isRequired'],
    };

    const validator = new Validator(lang);

    const {errors, isValid} = validator.validate(validatingData);

    store.dispatch('setValidationError', errors); //if component is valid, an empty state will be sent

    return {errors, isValid};
};
