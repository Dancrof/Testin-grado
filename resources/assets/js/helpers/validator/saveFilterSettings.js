import store from '../../../store'

import {Validator} from "../easy-validator";

import {lang} from '../extraLogics';

export function validateSaveFilterSettings(data){

    const { name, iconClass } = data;

    let validatingData = {

        name: [name, 'isRequired'],
        
        iconClass: [iconClass, 'isRequired']
    };
    
    const validator = new Validator(lang);

    const {errors, isValid} = validator.validate(validatingData);

    store.dispatch('setValidationError', errors);
  
    return {errors, isValid};
};