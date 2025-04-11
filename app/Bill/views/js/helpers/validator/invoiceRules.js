
import store from "../../../../../../resources/assets/store";

import {Validator} from "../../../../../../resources/assets/js/helpers/easy-validator";

import {lang} from "../../../../../../resources/assets/js/helpers/extraLogics";


export function validateInvoiceSettings(data){

    const { packages } = data;

    let validatingData = {};

    if(data.packages){

        validatingData['price'] = [data.packages.price, 'isRequired']
    }
   
    const validator = new Validator(lang);

    const {errors, isValid} = validator.validate(validatingData);

    store.dispatch('setValidationError', errors);
  
    return {errors, isValid};
};

