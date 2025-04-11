import store from '../../../store'

import {Validator} from "../easy-validator";

import {lang} from '../extraLogics';

export function validateSourceSettings(data){

    const { name, display_as, description, icon } = data;

    let validatingData = {

        name: [name, 'isRequired', { 'max(20)' : lang('name_should_be_less_than_20_characters')}],

        icon: [icon, 'isRequired'],
        
        display_as: [display_as, 'isRequired', { 'max(20)' : lang('display_as_should_be_less_than_20_characters')}],

        description: [description,{ 'max(100)' : lang('descripton_should_be_less_than_100_characters')}]
    };
    
    const validator = new Validator(lang);

    const {errors, isValid} = validator.validate(validatingData);

    store.dispatch('setValidationError', errors);
  
    return {errors, isValid};
};