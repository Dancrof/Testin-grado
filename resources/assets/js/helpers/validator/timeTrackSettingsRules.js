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
export function validateTimeTrackSettings(data){


    const { description, worktime, actions, worktime_type} = data;

    //rules has to apply only after checking conditions
    let validatingData = {
        description: [description, 'isRequired'],
        worktime: [worktime, 'isRequired', 'minValue(1)', 'maxValue(609940)'],
    };

    if(actions.show_worktime_type && actions.require_worktime_type_field && worktime) {
        validatingData['worktime_type'] = [worktime_type, 'isRequired'];
    }

    //creating a validator instance and pasing lang method to it
    const validator = new Validator(lang);
    const {errors, isValid} = validator.validate(validatingData);

    // write to vuex if errors
    store.dispatch('setValidationError', errors); //if component is valid, an empty state will be sent
  
    return {errors, isValid};
};

