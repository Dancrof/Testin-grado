import store from '../../../../store'

import {Validator} from "../../easy-validator";

import {lang} from '../../extraLogics';

export function ticketFormValidation(data)
{

    let validatingData = {

        selectedForm: [data.selectedForm, 'isRequired'],
    };

    const validator = new Validator(lang);

    const {errors, isValid} = validator.validate(validatingData);

    store.dispatch('setValidationError', errors);

    return {errors, isValid};
}