import store from '../../../store'

import {Validator} from "../easy-validator";

import {lang} from '../extraLogics';

export function validateKbSettings(data){

    const { pagination} = data;

    let validatingData = {

        pagination : [ pagination, 'isRequired', 'minValue(10)', 'maxValue(15)' ],
    };
    
    const validator = new Validator(lang);

    const {errors, isValid} = validator.validate(validatingData);

    store.dispatch('setValidationError', errors); 
  
    return {errors, isValid};
};

