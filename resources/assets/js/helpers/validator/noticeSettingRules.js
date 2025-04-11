import store from '../../../store'

import {Validator} from "../easy-validator";

import {lang} from '../extraLogics';

export function validateNoticeSettings(data){

    const { days_to_delete } = data;

    let validatingData = {

        days_to_delete: [days_to_delete, 'isRequired', { 'minValue(1)' : lang('invalid_input')}]
    };

    const validator = new Validator(lang);

    const {errors, isValid} = validator.validate(validatingData);

    store.dispatch('setValidationError', errors); //if component is valid, an empty state will be sent

    return {errors, isValid};
};
