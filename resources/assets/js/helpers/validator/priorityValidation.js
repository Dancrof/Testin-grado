import store from '../../../store'

import {Validator} from "../easy-validator";

import {lang} from '../extraLogics';

export function validatePrioritySettings(data){

    const { name, priority_desc, priority_color } = data;

    let validatingData = {

        name: [name, 'isRequired', { 'max(50)' : lang('priority_should_be_less_than_50_characters')}],
        
        priority_desc: [priority_desc, 'isRequired', { 'max(255)' : lang('priority_description_should_be_less_than_255_characters')}],

        priority_color: [priority_color, 'isRequired'],
    };
    
    const validator = new Validator(lang);

    const {errors, isValid} = validator.validate(validatingData);

    store.dispatch('setValidationError', errors);
  
    return {errors, isValid};
};