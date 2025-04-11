import store from '../../../store'

import {Validator} from "../easy-validator";

import {lang} from '../extraLogics';

export function validateOrgDeptSettings(data){

    const { org_deptname, business_hours } = data;

    let validatingData = {

        org_deptname: [org_deptname, 'isRequired', 'max(20)'],

        business_hours: [business_hours],
    };

    //creating a validator instance and pasing lang method to it
    const validator = new Validator(lang);

    const {errors, isValid} = validator.validate(validatingData);

    // write to vuex if errors
    store.dispatch('setValidationError', errors); //if component is valid, an empty state will be sent

    return {errors, isValid};
};
