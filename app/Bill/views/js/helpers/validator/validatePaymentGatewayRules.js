
import store from "../../../../../../resources/assets/store";

import {Validator} from "../../../../../../resources/assets/js/helpers/easy-validator";

import {lang} from "../../../../../../resources/assets/js/helpers/extraLogics";

export function validatePaymentGatewaySettings(data){

    const { extraTextFields } = data;

    let validatingData = {};

    for(var i in data.extraTextFields){
        validatingData[data.extraTextFields[i].name] = [data.extraTextFields[i].value, 'isRequired']
    }
    // if(data.credit_type === 1){

    //     validatingData['allowed_tickets'] = [allowed_tickets, 'isRequired']
    // } else {
    //     console.log(data)
    //     validatingData['validity'] = [validity, 'isRequired']
        
    // }
   
    const validator = new Validator(lang);

    const {errors, isValid} = validator.validate(validatingData);

    store.dispatch('setValidationError', errors); //if component is valid, an empty state will be sent
  
    return {errors, isValid};
};

