import store from '../../../store'

import {Validator} from "../easy-validator";

import {lang} from '../extraLogics';

export function securitySettingsValidation(data)
{
    
    const { backlist_threshold, lockout_period, lockout_message, max_attempts, expiry_time, password_reset_attempts_awaiting_time } = data;
    
    let validatingData = {

        lockout_period : [lockout_period, 'isRequired'],

        backlist_threshold : [backlist_threshold, 'isRequired'],

        max_attempts : [max_attempts, 'isRequired',
            {'maxValue(3)' : lang('password_reset_max_attempts')},
            {'minValue(1)' : lang('password_reset_min_attempts')}
        ],
        expiry_time : [expiry_time, 'isRequired',
            {'maxValue(30)' : lang('password_reset_min_expiry')},
            {'minValue(5)' : lang('password_reset_max_expiry')}
        ],

        password_reset_attempts_awaiting_time : [password_reset_attempts_awaiting_time, 'isRequired',
            {'maxValue(43200)' : lang('password_reset_attempts_awaiting_time_max')},
            {'minValue(30)' : lang('password_reset_attempts_awaiting_time_min')}
        ],
    };
    
    //creating a validator instance and pasing lang method to it
    const validator = new Validator(lang);

    const {errors, isValid} = validator.validate(validatingData);

    // write to vuex if errors
    store.dispatch('setValidationError', errors); //if component is valid, an empty state will be sent
  
    return {errors, isValid}
};


