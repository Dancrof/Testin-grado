import store from '../../../../store'

import {Validator} from "../../easy-validator";

import {lang} from '../../extraLogics';

export function createTicketFormValidation(data){

    let validatingData = {

        name: [data.name, 'isRequired'],
    };

    const validator = new Validator(lang);

    const {errors, isValid} = validator.validate(validatingData);

    store.dispatch('setValidationError', errors);

    return {errors, isValid};
};