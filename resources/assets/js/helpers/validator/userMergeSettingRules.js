import store from '../../../store'

import {Validator} from "../easy-validator";

import {lang} from '../extraLogics';

export function userMergeSettingRules(data){
    let {parentUser, childUser} = data;

    if(parentUser==null){
        parentUser='';
    }
        var validatingData = {

            parentUser: [parentUser, 'isRequired'],

            childUser: [childUser, 'isRequired'],
        };
    const validator = new Validator(lang);

    const {errors, isValid} = validator.validate(validatingData);

    store.dispatch('setValidationError', errors); //if component is valid, an empty state will be sent

    return {errors, isValid};

}