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
export function validateArticleSettings (data){

    const {name,category,author,visible_to,publish_time,slug,summary,organization_id} = data;

    //rules has to apply only after checking conditions
    let validatingData = {
        name: [name, 'isRequired'],
        category: [category, 'isRequired'],
        author: [author, 'isRequired'],
        visible_to : [visible_to, 'isRequired'],
        publish_time : [publish_time, 'isRequired'],
        slug : [slug, 'isRequired'],
        summary: [summary, 'isRequired']
    };
    
    if(data.visible_to === 'organization_members'){
       
      validatingData['organization_id'] = [data.organization_id,'isRequired'];
       
    }

    //creating a validator instance and pasing lang method to it
    const validator = new Validator(lang);

    const {errors, isValid} = validator.validate(validatingData);

    // write to vuex if errors
    store.dispatch('setValidationError', errors); //if component is valid, an empty state will be sent
  
    return {errors, isValid};
}

