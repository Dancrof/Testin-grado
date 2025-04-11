import store from "../../../../../store";

import { Validator } from "../../../../helpers/easy-validator";

import { lang } from "../../../../helpers/extraLogics";

export function validateRatingSettings(data) {
  
  const { name, rating_scale, thank_you_message,  auto_reminder, reminder_time_interval, total_number_of_reminders} = data

  var validatingData = {
    
    name: [name, 'isRequired'],
    
    rating_scale: [rating_scale, 'isRequired'],
    
    thank_you_message: [thank_you_message, 'isRequired'],

  };

  if(data. auto_reminder){
    validatingData['reminder_time_interval'] = [data.reminder_time_interval, 'isRequired' ,  { 'minValue(1)' : 'The value should be greater than 1.'},{ 'maxValue(15)' : 'The value should be lesser than 15.'}];

    validatingData['total_number_of_reminders'] = [data.total_number_of_reminders, 'isRequired', { 'minValue(1)' : 'The value should be greater than 1.'},{ 'maxValue(4)' : 'The value should be lesser than 4.'}];
  }

  const validator = new Validator(lang);

  const { errors, isValid } = validator.validate(validatingData);

  store.dispatch('setValidationError', errors);

  return isValid;
}