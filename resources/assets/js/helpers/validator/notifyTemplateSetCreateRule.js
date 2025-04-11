import store from '../../../store'

import {Validator} from "../easy-validator";

import {lang} from '../extraLogics';

export function validateNotifyTemplateSet(data){

    const { name, template_language, parent_template_set } = data;

    let validatingData = {
        
        name: [name, 'isRequired'],
        
        template_language: [template_language, 'isRequired'],

        parent_template_set: [parent_template_set, 'isRequired'],
    };
    
    //creating a validator instance and pasing lang method to it
    const validator = new Validator(lang);

    const {errors, isValid} = validator.validate(validatingData);

    // write to vuex if errors
    store.dispatch('setValidationError', errors); //if component is valid, an empty state will be sent
  
    return {errors, isValid};
};
