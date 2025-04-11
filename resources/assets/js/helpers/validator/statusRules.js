import store from '../../../store'

import {Validator} from "../easy-validator";

import {lang} from '../extraLogics';

export function validateStatusSettings(data){

    const { name, sort, order, icon_class, purpose_of_status, visibility_for_client, secondary_status, override_status, override_statuses} = data;

    let validatingData = { 
    	name: [name, 'isRequired'], 
    	sort: [sort, 'isRequired'], 
    	icon_class: [icon_class, 'isRequired'],
    	order: [order, 'isRequired'],
    	purpose_of_status: [purpose_of_status, 'isRequired'],
    };

    if(!data.visibility_for_client) {

    	validatingData['secondary_status'] = [secondary_status, 'isRequired'];
    }

    if(!data.override_status) {
    	
    	validatingData['override_statuses'] = [override_statuses, 'isRequired'];
    }
    
    const validator = new Validator(lang);

    const {errors, isValid} = validator.validate(validatingData);

    store.dispatch('setValidationError', errors); //if component is valid, an empty state will be sent
  
    return {errors, isValid};
};
