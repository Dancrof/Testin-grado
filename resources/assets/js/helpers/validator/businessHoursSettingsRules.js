/**
 * This file contains all the validation rules specific to form.
 *
 * RULES : method name for the form should be 'validateFormName'
 * */

import store from '../../../store'
import {Validator} from "../easy-validator";
import {lang} from '../extraLogics';
import moment from "moment";

/**
 * @param {object} data      emailSettings component data
 * @return {object}          object of errors and isValid (form is valid or not)
 * */
export function validateHolidaySettings(data){


    const { holiday_description, date} = data;

    //rules has to apply only after checking conditions
    let validatingData = {

        holiday_description: [holiday_description, 'isRequired'],
        date: [date, 'isRequired'],
    };

    //creating a validator instance and pasing lang method to it
    const validator = new Validator(lang);

    const {errors, isValid} = validator.validate(validatingData);

    // write to vuex if errors
    store.dispatch('setValidationError', errors); //if component is valid, an empty state will be sent

    return {errors, isValid};
};

/**
 * @param {object} data      emailSettings component data
 * @return {object}          object of errors and isValid (form is valid or not)
 * */
export function validateBusinessHoursSettings(data){

    const { name,description,timezone,dateWithTime,hours} = data;

    let validatingData = {
        name: [name, 'isRequired'],
        description: [description, 'isRequired'],
        timezone: [timezone, 'isRequired']
    }

    let isValid, errors;

    if(hours === 1){

        dateWithTime.map((field,index) => {

            if(field.status === 'Open_custom'){

                validatingData['open_time'+index] = [field.open_time, 'isRequired'];

                validatingData['close_time'+index] = [field.close_time, 'isRequired'];
            }
        })

        isValid = validateOpenAndClose(dateWithTime)
    }

    const validator = new Validator(lang);

    const validatorData = validator.validate(validatingData);

    errors = validatorData.errors;

    if(hours === 1) {

        isValid = !isValid ? isValid : validatorData.isValid;

    } else {

        isValid = validatorData.isValid;
    }

    store.dispatch('setValidationError', errors);

    return {errors, isValid};
};

function validateOpenAndClose(open_close){

    let missingScenarios = 0;

    open_close.map((value) => {

        if(typeof value.open_time == 'object') {
            value.open_time = moment(value.open_time).format("HH:mm")
        }

        if(typeof value.close_time == 'object') {
            value.close_time = moment(value.close_time).format("HH:mm")
        }

        if(value.status == "Open_custom" && value.open_time == value.close_time) {

            let message = lang('open_and_close_should_not_be_same');

            missingScenarios++;

            store.dispatch('setAlert', { type: 'danger', message: message, component_name: 'hours-table' })
        }

        if(value.status == "Open_custom" && value.open_time > value.close_time) {

            let message = lang('open_time_should_be_less_than_close_time');

            missingScenarios++;

            store.dispatch('setAlert', { type: 'danger', message: message, component_name: 'hours-table' })
        }
    })

    if(missingScenarios > 0){

        return false;
    }

    return true;
}
