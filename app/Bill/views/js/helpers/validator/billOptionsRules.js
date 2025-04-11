import store from "../../../../../../resources/assets/store";

import {Validator} from "../../../../../../resources/assets/js/helpers/easy-validator";

import {lang} from "../../../../../../resources/assets/js/helpers/extraLogics";

export function billOptionsValidation(data){

    const { invoice_due, currency } = data;

    let validatingData = {
        
        invoice_due: [invoice_due,'minValue(1)', 'isRequired'],

        currency: [currency, 'isRequired'],
    };

    const validator = new Validator(lang);

    const {errors, isValid} = validator.validate(validatingData);

    store.dispatch('setValidationError', errors); //if component is valid, an empty state will be sent
  
    return {errors, isValid};
};

