import store from '../../../store'

import {Validator} from "../easy-validator";

import {lang} from '../extraLogics';

export function validateNoteSettings(data){

    const { internal_note, worktime, worktime_type} = data;

    let validatingData = {

        internal_note: [internal_note, 'isRequired']
    };

    let actions = store.getters.getTicketActions;

    if (actions.show_thread_worktime && actions.require_thread_worktime) {
        validatingData['worktime'] = [worktime, 'isRequired', 'minValue(1)'];
    }

    if (actions.show_worktime_type && actions.require_worktime_type_field && worktime) {
        validatingData['worktime_type'] = [worktime_type, 'isRequired'];
    }

    const validator = new Validator(lang);

    const {errors, isValid} = validator.validate(validatingData);

    store.dispatch('setValidationError', errors); //if component is valid, an empty state will be sent

    return {errors, isValid};
};
