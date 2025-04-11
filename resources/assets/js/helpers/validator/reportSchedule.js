import store from "../../../store";

import { Validator } from "../easy-validator";

import { lang } from "../extraLogics";

// Function to validate schedule data
export function validateSchedule(data) {
    // Define data and their validation rules
    let validatingData = {

        schedule: [data.schedule, 'isRequired'],

        delivery_time: [data.delivery_time, 'isRequired'],

        notify_persons: [data.notify_persons, 'isRequired'],

        subject: [data.subject, 'isRequired']
    };

    // If not a 'daily' schedule, validate 'day' as well
    if (data.schedule !== 'daily') {

        validatingData['day'] = [data.day, 'isRequired'];
    }

    // Create a Validator instance with language settings
    const validator = new Validator(lang);

    // Validate the data using the defined rules
    const { errors, isValid } = validator.validate(validatingData);

    // Send validation errors to the store
    store.dispatch('setValidationError', errors);

    // Return validation results (errors and validity)
    return { errors, isValid };
}