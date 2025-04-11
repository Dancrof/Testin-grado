/**
 * This file contains all the validation rules specific to form.
 *
 * RULES : method name for the form should be 'validateFormName'
 * */

import store from '../../../store'
import {Validator} from "../easy-validator";
import {lang} from '../extraLogics';

/**
 * @param {object} data      emailSettings component data
 * @return {object}          object of errors and isValid (form is valid or not)
 * */
export function validateCategoryCreateSettings (data){

    const {name,display_order,description,slug} = data;

    //rules has to apply only after checking conditions
    let validatingData = {
        name: [name, 'isRequired'],
        display_order: [display_order, 'isRequired'],
        description: [description, 'isRequired'],
        slug : [slug, 'isRequired']
    };
    
    //creating a validator instance and pasing lang method to it
    const validator = new Validator(lang);

    const {errors, isValid} = validator.validate(validatingData);

    // write to vuex if errors
    store.dispatch('setValidationError', errors); //if component is valid, an empty state will be sent
  
    return {errors, isValid};
}

