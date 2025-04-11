import store from '../../../store'

import {Validator} from "../easy-validator";

import {lang} from '../extraLogics';

export function validateTeamSettings(data){

    const { name } = data;

    let validatingData = {

        name: [name, 'isRequired', {'max(30)' : lang('name_should_be_less_than_30_characters')}],
    };

    const validator = new Validator(lang);

    const {errors, isValid} = validator.validate(validatingData);

    store.dispatch('setValidationError', errors); //if component is valid, an empty state will be sent
  
    return {errors, isValid};
};