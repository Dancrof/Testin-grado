import store from '../../../store'

import {Validator} from "../easy-validator";

import {lang} from '../extraLogics';

export function companySettingsValidation(data)
{
    
    const { company_name, phone, website, admin_header_color, agent_header_color, agent_sidebar_color, admin_sidebar_color, address } = data;
    
    let validatingData = {
       
        company_name : [company_name, 'isRequired',{'max(50)' : lang('name_should_be_less_than_50_characters')}],

        phone : [phone,{ 'max(15)' : lang('phone_number_should_be_less_than_15_digits')}],

        address : [address,{ 'max(250)' : lang('address_should_be_less_than_250_characters')}],

        admin_header_color : [admin_header_color, 'isRequired'],

        agent_header_color : [agent_header_color, 'isRequired'],

        admin_sidebar_color : [admin_sidebar_color, 'isRequired'],
        
        agent_sidebar_color : [agent_sidebar_color, 'isRequired'],
    };
    
    //creating a validator instance and pasing lang method to it
    const validator = new Validator(lang);

    const {errors, isValid} = validator.validate(validatingData);

    // write to vuex if errors
    store.dispatch('setValidationError', errors); //if component is valid, an empty state will be sent
  
    return {errors, isValid}
};


