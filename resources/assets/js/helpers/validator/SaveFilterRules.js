import store from '../../../store';

import {Validator} from "../easy-validator";

import {lang} from '../extraLogics';

export function validateSaveFilter (data){

    const { display_order } = data;

    let validatingData = {


        display_order : [display_order, 'isRequired', {'minValue(1)': lang('display_order_tickets')}]
    };

    const validator = new Validator(lang);

    const {errors, isValid} = validator.validate(validatingData);

    store.dispatch('setValidationError', errors); //if component is valid, an empty state will be sent

    return {errors, isValid};
}