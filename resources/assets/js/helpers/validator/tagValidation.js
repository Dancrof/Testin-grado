import store from '../../../store'

import {Validator} from "../easy-validator";

import {lang} from '../extraLogics';

export function validateTagSettings(data){

    const { name, description, visible_to } = data;

    let validatingData = {

        name: [name, 'isRequired', { 'max(250)' : lang('tag_name_should_be_less_than_250_characters')}],

        visible_to: [visible_to, 'isRequired'],
        
        description: [description,{ 'max(50)' : lang('descripton_should_be_less_than_50_characters')}]
    };
    
    const validator = new Validator(lang);

    const {errors, isValid} = validator.validate(validatingData);

    store.dispatch('setValidationError', errors);
  
    return {errors, isValid};
};