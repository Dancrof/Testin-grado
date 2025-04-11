import store from "../../../../../../resources/assets/store";

import {Validator} from "../../../../../../resources/assets/js/helpers/easy-validator";

import {lang} from "../../../../../../resources/assets/js/helpers/extraLogics";

export function validateAutoAssignSettings(data){

    const { threshold, assign_department_option, department_list } = data;

    let validatingData = {};

    if(data.assign_department_option === 'specific'){

        validatingData['department_list'] = [data.department_list, 'isRequired']
    }
   
    const validator = new Validator(lang);

    const {errors, isValid} = validator.validate(validatingData);

    store.dispatch('setValidationError', errors); //if component is valid, an empty state will be sent
  
    return {errors, isValid};
};