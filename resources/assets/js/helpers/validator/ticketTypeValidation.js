import store from '../../../store'

import {Validator} from "../easy-validator";

import {lang} from '../extraLogics';

export function validateTicketTypeSettings(data){

    const { name, type_desc } = data;

    let validatingData = {

        name: [name, 'isRequired', { 'max(50)' : lang('name_should_be_less_than_50_characters')}],
        
        type_desc: [type_desc, 'isRequired', { 'max(50)' : lang('descripton_should_be_less_than_50_characters')}]
    };
    
    const validator = new Validator(lang);

    const {errors, isValid} = validator.validate(validatingData);

    store.dispatch('setValidationError', errors);
  
    return {errors, isValid};
};